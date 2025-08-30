#!/usr/bin/env bun
/// <reference lib="esnext" />

import unzipper from "unzipper";

import { $ } from "bun";
import fs from "node:fs/promises";
import path from "node:path";

const HOME = process.env.HOME;
const BASEDIR = import.meta.dir;
const THEMES = path.resolve(HOME, ".themes");

await Bun.write(path.resolve(HOME, ".local/share/settings_path"), BASEDIR);

link("shell/zshrc", ".zshrc");
link("shell/profile", ".profile");
link("shell/profile", ".xprofile");
link("shell/profile", ".bash_profile");
link("shell/profile", ".zprofile");
link("shell/profile", ".zlogin");
link("shell/profile", ".zshenv");
link("nvim", ".config/nvim");
link("kitty", ".config/kitty");
link("wallust", ".config/wallust");
link("hypr", ".config/hypr");
link("wlogout", ".config/wlogout");
link("nwg-panel", ".config/nwg-panel");
link("yazi", ".config/yazi");
link(".editorconfig", ".editorconfig");

themeZip("https://www.gnome-look.org/p/1876396", {
    "Dark.zip": ["MarshmallowDark"],
    "Light.zip": ["MarshmallowLight"],
});

/**
 * @param {string} localPath
 * @param {string} globalPath
 */
async function link(localPath, globalPath) {
    globalPath = path.resolve(HOME, globalPath);
    localPath = path.resolve(BASEDIR, localPath);
    const stat = await fs.lstat(globalPath).catch(() => null);
    if (stat) {
        if (
            stat.isSymbolicLink() &&
            path.resolve(await fs.readlink(globalPath)) === localPath
        ) {
            return;
        }
        await $`rm -rf ${globalPath}`;
    }
    await $`ln -sf ${localPath} ${globalPath}`;
    console.log(`Created symlink ${globalPath} -> ${localPath}`);
}

/**
 * @param {string} themeUrl
 * @param {Record<string, string>} fileNames
 */
async function themeZip(themeUrl, fileNames) {
    await fs.mkdir(THEMES, { recursive: true });

    const entries = Object.entries(fileNames);
    const themesStats = await asyncMap(
        entries.flatMap(([_, themeNames]) => themeNames),
        (themeName) => fs.stat(path.resolve(THEMES, themeName)).catch(() => null),
    );
    if (themesStats.every((x) => !!x)) return;

    console.log("Checking theme", themeUrl);

    const files = await fetch(path.join(themeUrl, "loadFiles"))
        .then((res) => res.json())
        .then((res) => res.files);

    await asyncEach(entries, async ([fileName, _]) => {
        let url = decodeURIComponent(files.find((x) => x.title === fileName).url);
        console.log("Downloading", url);
        const data = await fetch(url).then((res) => res.arrayBuffer());
        const zip = await unzipper.Open.buffer(Buffer.from(data));
        await zip.extract({ path: THEMES });

        const visited = new Set(
            zip.files.values().map((file) => file.path.split("/")[0]),
        );
        for (const path of visited.values()) {
            console.log("Added theme", path);
        }
    });
}

/**
 * @template T, U
 * @param {readonly T[] | IteratorObject<T>} it
 * @param {(item: T) => U} f
 */
async function asyncMap(it, f) {
    const items = await Promise.allSettled(it.map(f));
    return items.map((x) => {
        if (x.status === "rejected") throw reason;
        return x.value;
    });
}

/**
 * @template T
 * @param {readonly T[] | IteratorObject<T>} it
 * @param {(item: T) => void | PromiseLike<void>} f
 */
async function asyncEach(it, f) {
    const items = await Promise.allSettled(it.map(f));
    for (const x of items) {
        if (x.status === "rejected") throw x.reason;
    }
}
