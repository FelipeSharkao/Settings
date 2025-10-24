#!/usr/bin/env bun

import { parseArgs } from "node:util";
import fs from "node:fs";
import path from "node:path";
import childProcess from "node:child_process";

const { values } = parseArgs({
    options: {
        theme: { type: "string", short: "t", default: "auto" },
        dir: { type: "string", short: "d", default: "~/Pictures/Wallpapers" },
        "keep-wallpaper": { type: "boolean", short: "k" },
        help: { type: "boolean", short: "h" },
    },
});

if (values.help) {
    showHelp(0);
}

/** @type {"light" | "dark"} */
let theme;
switch (values.theme) {
    case "light":
        theme = "light";
        break;
    case "dark":
        theme = "dark";
        break;
    case "auto": {
        const hour = new Date().getHours();
        theme = 6 <= hour && hour < 18 ? "light" : "dark";
        break;
    }
    default:
        showHelp(1);
}

let palette, gtkTheme, gtkColorScheme;
switch (theme) {
    case "light":
        palette = "light16";
        gtkTheme = "MarshmallowLight";
        gtkColorScheme = "prefer-light";
        break;
    case "dark":
        palette = "dark16";
        gtkTheme = "MarshmallowDark";
        gtkColorScheme = "prefer-dark";
        break;
}

let wallpaper;
if (values["keep-wallpaper"]) {
    wallpaper = trimNewLine(await Bun.file(`${process.env.HOME}/.cache/wal/wal`).text());
} else {
    const dir = resolvePath(values.dir);
    const dirStat = await fs.promises.stat(dir);
    if (!dirStat.isDirectory()) {
        showHelp(1);
    }

    const files = await fs.promises.readdir(dir);
    wallpaper = path.join(dir, files[Math.floor(Math.random() * files.length)]);
}

console.log(`Setting wallpaper to ${wallpaper}`);

console.log("Setting swaybg...");
await cmd("killall", "swaybg");
await cmd("swaybg", "--image", wallpaper, "--mode", "fill").disown();

console.log("Setting gnome background...");
await cmd(
    "gsettings",
    "set",
    "org.gnome.desktop.background",
    "picture-uri",
    `file://${wallpaper}`,
);
await cmd(
    "gsettings",
    "set",
    "org.gnome.desktop.background",
    "picture-uri-dark",
    `file://${wallpaper}`,
);

console.log("Setting GTK theme...");
await cmd("gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", gtkTheme);
await cmd(
    "gsettings",
    "set",
    "org.gnome.desktop.interface",
    "color-scheme",
    gtkColorScheme,
);

console.log("Running wallust...");
await cmd("wallust", "run", "-p", palette, wallpaper);

console.log("Updating kitty...");
await cmd(
    "kitten",
    "@",
    "set-colors",
    "--all",
    "~/.cache/wal/colors-kitty.conf",
).disown();

console.log("Resetting nwg-panel...");
await cmd("killall", "nwg-panel");
await cmd("nwg-panel").disown();

console.log("Resetting mako...");
await cmd("killall", "mako");
await cmd("mako").disown();

console.log("Uptating pywalfox...");
await cmd("pywalfox", "update").disown();

console.log("Notifying neovim...");
for (const server of await cmd("nvr", "--serverlist").lines()) {
    await cmd("nvr", "--nostart", "--servername", server, "+colorscheme wal").disown();
}

/**
 * @param {number} status
 * @returns {never}
 */
function showHelp(status) {
    const m =
        `Usage: ${process.argv[1]} [options]\n` +
        `\n` +
        `Options:\n` +
        `  -t, --theme <theme>  Set the theme (auto, light, dark)\n` +
        `  -d, --dir <dir>      Set the directory to look for wallpapers (default: ~/Pictures/Wallpapers)\n` +
        `  -k, --keep-wallpaper Keep the current wallpaper\n` +
        `  -h, --help           Show this help`;

    if (status === 0) {
        console.log(m);
    } else {
        console.error(m);
    }

    process.exit(status);
}

/**
 * @param {string} path_
 * @returns {string}
 */
function resolvePath(path_) {
    if (path_.startsWith("~" + path.sep)) {
        path_ = `${process.env.HOME}${path_.slice(1)}`;
    }
    return path.resolve(path_);
}

/** @param {string} str */
function trimNewLine(str) {
    if (str.endsWith("\n")) {
        return str.slice(0, -1);
    }
    return str;
}

/**
 * @param {...string} command
 */
function cmd(...command) {
    return new Process(command);
}

/**
 * @typedef {object} ProcessOutput
 * @property {number} code
 * @property {string} stdout
 * @property {string} stderr
 */

/**
 * @template T
 * @typedef {T | PromiseLike<T>} Awaitable
 */

class Process {
    /**
     * @param {string[]} command
     */
    constructor(command) {
        this._command = command;
    }

    /**
     * @returns {Promise<ProcessOutput>}
     */
    exec() {
        const child = childProcess.spawn(this._command[0], this._command.slice(1), {
            stdio: "pipe",
        });

        let stdout = "";
        let stderr = "";
        let stdoutPending = "";
        let stderrPending = "";

        child.stdout.on("data", (data) => {
            data = String(data);
            stdout += data;

            if (!this._quiet) {
                const lines = (stdoutPending + data).split("\n");
                stdoutPending = lines.pop() || "";
                for (const line of lines) {
                    console.log(line);
                }
            }
        });

        child.stderr.on("data", (data) => {
            data = String(data);
            stderr += data;

            if (!this._quiet) {
                const lines = (stderrPending + data).split("\n");
                stderrPending = lines.pop() || "";
                for (const line of lines) {
                    console.error(line);
                }
            }
        });

        return new Promise((resolve, reject) => {
            child.on("error", reject);
            child.on("exit", (code) => {
                if (this._quiet) {
                    if (code !== 0) {
                        console.error(trimNewLine(stderr));
                    }
                } else {
                    if (stdoutPending) {
                        console.log(stdoutPending);
                    }
                    if (stderrPending) {
                        console.error(stderrPending);
                    }
                }
                resolve({ code, stdout, stderr });
            });
        });
    }

    async text() {
        this._quiet = true;
        const { stdout } = await this.exec();
        return stdout;
    }

    async lines() {
        const text = await this.text();
        const lines = text.split("\n");
        if (lines.at(-1) === "") {
            lines.pop();
        }
        return lines;
    }

    async quiet() {
        this._quiet = true;
        return this;
    }

    /**
     * @returns {Promise<void>}
     */
    disown() {
        const child = childProcess.spawn(this._command[0], this._command.slice(1), {
            stdio: "ignore",
            detached: true,
        });

        child.unref();

        return new Promise((resolve, reject) => {
            child.on("error", reject);
            child.on("spawn", () => resolve());
        });
    }

    /**
     * @template T
     * @param {(value: ProcessOutput) => Awaitable<T>} [onResolve]
     * @param {(error: Error) => Awaitable<T>} [onReject]
     * @returns {Promise<T>}
     */
    then(onResolve, onReject) {
        return this.exec().then(onResolve, onReject);
    }

    /** @type {string[]} */
    _command;
    _quiet = false;
}
