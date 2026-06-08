#!/usr/bin/env bun

import { parseArgs } from "node:util"
import fs from "node:fs"
import path from "node:path"
import childProcess from "node:child_process"
import { TOML, $ } from "bun"

import { set } from "date-fns"
import dbus from "dbus-next"

const DIM = "\x1b[2m"
const RESET = "\x1b[0m"

const SCHEDULE_INTERVAL = 5 * 60_000 // 5 minutes

const EXTRACT_MODES = [
    "colorful",
    "triadic",
    "split-complementary",
    "tetradic",
    "ocean",
    "sunset",
    "vaporwave",
    "aurora",
]

const { values } = parseArgs({
    options: {
        theme: { type: "string", short: "t", default: "auto" },
        file: { type: "string", short: "f" },
        dir: { type: "string", short: "d", default: "~/Pictures/Wallpapers" },
        "keep-wallpaper": { type: "boolean", short: "k" },
        schedule: { type: "boolean" },
        help: { type: "boolean", short: "h" },
    },
})

if (values.help) {
    showHelp(0)
}

await run()
if (values.schedule) {
    await schedule()
}

async function run() {
    /** @type {"light" | "dark"} */
    let theme
    switch (values.theme) {
        case "light":
            theme = "light"
            break
        case "dark":
            theme = "dark"
            break
        case "auto": {
            const hour = new Date().getHours()
            theme = 6 <= hour && hour < 18 ? "light" : "dark"
            break
        }
        default:
            showHelp(1)
    }

    let palette, gtkTheme, gtkColorScheme
    switch (theme) {
        case "light":
            palette = "light16"
            gtkTheme = "MarshmallowLight"
            gtkColorScheme = "prefer-light"
            break
        case "dark":
            palette = "dark16"
            gtkTheme = "MarshmallowDark"
            gtkColorScheme = "prefer-dark"
            break
    }

    let wallpaper
    if (values["keep-wallpaper"]) {
        const metadata = await loadMetadata()
        wallpaper = metadata?.wallpaper
    } else if (values.file) {
        wallpaper = resolvePath(values.file)
    } else {
        const dir = resolvePath(values.dir)
        const dirStat = await fs.promises.stat(dir).catch(() => null)
        if (!dirStat?.isDirectory()) {
            console.error(`[ERR] ${JSON.stringify(dir)} is not a directory`)
            showHelp(1)
        }

        const files = await fs.promises.readdir(dir)
        const random = Math.floor(Math.random() * files.length)
        for (let i = 0; i < files.length; i++) {
            const idx = (i + random) % files.length
            const file = path.join(dir, files[idx])
            if (!(await isValidWallpaper(file))) continue
            wallpaper = file
        }

        if (!wallpaper) {
            console.error(`[ERR] No valid wallpapers found in ${JSON.stringify(dir)}`)
            showHelp(1)
        }
    }

    if (!(await isValidWallpaper(wallpaper))) {
        console.error(`[ERR] ${JSON.stringify(wallpaper)} is not a valid wallpaper`)
        showHelp(1)
    }

    console.log(`[LOG] Setting wallpaper to ${wallpaper}`)

    await cmd(
        "aether",
        "--generate",
        theme === "light" ? "--light-mode" : [],
        "--extract-mode",
        EXTRACT_MODES[Math.floor(Math.random() * EXTRACT_MODES.length)],
        "--no-neovim",
        wallpaper,
    )

    await printColors()

    await cmd("killall", "swaybg")
    await cmd("swaybg", "--image", wallpaper, "--mode", "fill").disown()

    const gtkBackgroundCmd = ["gsettings", "set", "org.gnome.desktop.background"]
    await cmd(gtkBackgroundCmd, "picture-uri", `file://${wallpaper}`)
    await cmd(gtkBackgroundCmd, "picture-uri-dark", `file://${wallpaper}`)

    const gtkInterfaceCmd = ["gsettings", "set", "org.gnome.desktop.interface"]
    await cmd(gtkInterfaceCmd, "gtk-theme", gtkTheme)
    await cmd(gtkInterfaceCmd, "color-scheme", gtkColorScheme)

    for (const pid of await cmd("pgrep", "kitty").lines()) {
        const socket = `unix:@kitty-control-${pid}`
        await cmd(
            "kitty",
            "@",
            "--to",
            socket,
            "set-colors",
            "--all",
            "~/.config/aether/theme/kitty.conf",
        )
    }

    await storeMetadata({ wallpaper })
}

async function isValidWallpaper(wallpaper) {
    if (
        !wallpaper
        || (!wallpaper.endsWith(".jpg")
            && !wallpaper.endsWith(".jpeg")
            && !wallpaper.endsWith(".png")
            && !wallpaper.endsWith(".webp"))
    )
        return false

    const stat = await fs.promises.stat(wallpaper).catch(() => null)
    return stat?.isFile()
}

async function printColors() {
    try {
        const colorsToml = await Bun.file(
            `${process.env.HOME}/.config/aether/theme/colors.toml`,
        ).text()
        const colors = TOML.parse(colorsToml)

        let s = ""
        for (let i = 0; i < 16; i++) {
            if (i % 8 === 0) {
                s += "\n"
            }
            const color = colors[`color${i}`]
            const r = parseInt(color.slice(1, 3), 16)
            const g = parseInt(color.slice(3, 5), 16)
            const b = parseInt(color.slice(5, 7), 16)
            s += `\x1b[48;2;${r};${g};${b}m    ${RESET}`
        }

        console.log(s + "\n")
    } catch (e) {
        console.error(e.message)
    }
}

async function schedule() {
    if (!values.schedule) return

    const bus = dbus.systemBus()
    const proxy = await bus.getProxyObject(
        "org.freedesktop.login1",
        "/org/freedesktop/login1",
    )

    const manager = proxy.getInterface("org.freedesktop.login1.Manager")
    manager.on("PrepareForSleep", (active) => {
        if (!active) {
            run()
        }
    })

    while (true) {
        await Bun.sleep(SCHEDULE_INTERVAL)

        const metadata = await loadMetadata()
        if (!metadata) continue

        const lastRun = new Date(metadata.timestamp)

        const now = new Date()
        const dawn = setTime(now, 6, 0)
        const midday = setTime(now, 12, 0)
        const dusk = setTime(now, 18, 0)

        if (
            (lastRun < dusk && dusk <= now)
            || (lastRun < midday && midday <= now)
            || (lastRun < dawn && dawn <= now)
        ) {
            await run()
        }
    }
}

/**
 * @typedef {object} Metadata
 * @property {string} wallpaper
 * @property {string} timestamp
 */

/**
 * @param {Omit<Metadata, "timestamp">} opts
 */
async function storeMetadata(opts) {
    await Bun.write(
        `${process.env.HOME}/.cache/wallpaper.json`,
        JSON.stringify({ ...opts, timestamp: new Date().toISOString() }, null, 2),
    )
}

/**
 * @returns {Promise<Metadata | null>}
 */
async function loadMetadata() {
    try {
        const timestamp = await Bun.file(
            `${process.env.HOME}/.cache/wallpaper.json`,
        ).text()
        return JSON.parse(timestamp)
    } catch {
        return null
    }
}

/**
 * @param {number} status
 * @returns {never}
 */
function showHelp(status) {
    const m =
        `Usage: ${process.argv[1]} [options]\n`
        + `\n`
        + `Options:\n`
        + `  -t, --theme <theme>  Set the theme (auto, light, dark)\n`
        + `  -f, --file <file>    Set the wallpaper file\n`
        + `  -d, --dir <dir>      Set the directory to look for wallpapers (default: ~/Pictures/Wallpapers)\n`
        + `  -k, --keep-wallpaper Keep the current wallpaper\n`
        + `      --schedule       Schedule the wallpaper/theme change. This keeps the service alive\n`
        + `  -h, --help           Show this help`

    if (status === 0) {
        console.log(m)
    } else {
        console.error(m)
    }

    process.exit(status)
}

/**
 * @param {string} path_
 * @returns {string}
 */
function resolvePath(path_) {
    if (path_.startsWith("~" + path.sep)) {
        path_ = `${process.env.HOME}${path_.slice(1)}`
    }
    return path.resolve(path_)
}

/** @param {string} str */
function trimNewLine(str) {
    if (str.endsWith("\n")) {
        return str.slice(0, -1)
    }
    return str
}

/**
 * @param {...string | string[]} command
 */
function cmd(...command) {
    return new Process(command.flat())
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
        this._command = command
    }

    /**
     * @returns {Promise<ProcessOutput>}
     */
    exec() {
        if (!this._quiet) {
            this.printCommand()
        }

        const child = childProcess.spawn(this._command[0], this._command.slice(1), {
            stdio: "pipe",
        })

        let stdout = ""
        let stderr = ""
        let stdoutPending = ""
        let stderrPending = ""

        child.stdout.on("data", (data) => {
            data = String(data)
            stdout += data

            if (!this._quiet) {
                const lines = (stdoutPending + data).split("\n")
                stdoutPending = lines.pop() || ""
                for (const line of lines) {
                    console.log(line)
                }
            }
        })

        child.stderr.on("data", (data) => {
            data = String(data)
            stderr += data

            if (!this._quiet) {
                const lines = (stderrPending + data).split("\n")
                stderrPending = lines.pop() || ""
                for (const line of lines) {
                    console.error(line)
                }
            }
        })

        return new Promise((resolve, reject) => {
            child.on("error", reject)
            child.on("exit", (code) => {
                if (this._quiet) {
                    if (code !== 0) {
                        this.printCommand()
                        console.error(trimNewLine(stderr))
                    }
                } else {
                    if (stdoutPending) {
                        console.log(stdoutPending)
                    }
                    if (stderrPending) {
                        console.error(stderrPending)
                    }
                }
                resolve({ code, stdout, stderr })
            })
        })
    }

    async text() {
        this._quiet = true
        const { stdout } = await this.exec()
        return stdout
    }

    async lines() {
        const text = await this.text()
        const lines = text.split("\n")
        if (lines.at(-1) === "") {
            lines.pop()
        }
        return lines
    }

    async quiet() {
        this._quiet = true
        return this
    }

    /**
     * @returns {Promise<void>}
     */
    disown() {
        this.printCommand({ disown: true })

        const child = childProcess.spawn(this._command[0], this._command.slice(1), {
            stdio: "ignore",
            detached: true,
        })

        child.unref()

        return new Promise((resolve, reject) => {
            child.on("error", reject)
            child.on("spawn", () => resolve())
        })
    }

    /**
     * @param {object} [opts]
     * @param {boolean} [opts.disown]
     */
    printCommand(opts) {
        const command = this.formatedCommand(opts)
        console.log(`${DIM}$ ${command}${RESET}`)
    }

    /**
     * @param {object} [opts]
     * @param {boolean} [opts.disown]
     */
    formatedCommand(opts) {
        let command = this._command.map((x) => $.escape(x)).join(" ")
        if (opts?.disown) {
            command += " & disown"
        }
        return command
    }

    /**
     * @template T
     * @param {(value: ProcessOutput) => Awaitable<T>} [onResolve]
     * @param {(error: Error) => Awaitable<T>} [onReject]
     * @returns {Promise<T>}
     */
    then(onResolve, onReject) {
        return this.exec().then(onResolve, onReject)
    }

    /** @type {string[]} */
    _command
    _quiet = false
}

function setTime(date, hours, minutes, seconds = 0, milliseconds = 0) {
    return set(date, { hours, minutes, seconds, milliseconds })
}
