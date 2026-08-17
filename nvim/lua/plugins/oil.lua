require("lazy")

local keymaps = {
    ["<BS>"] = "actions.parent",
    ["<C-h>"] = "actions.toggle_hidden",
    ["<leader>:"] = {
        "actions.open_cmdline",
        opts = { shorten_path = true, modify = ":h" },
        desc = "Open the cmdline with the directory as an argument",
    },
}

-- Sort order keys, same as yazi
for _, opts in ipairs({
    { key = "b", col = "ctime", desc = "by birth time" },
    { key = "m", col = "mtime", desc = "by modified time" },
    { key = "n", col = "name", desc = "by name" },
    { key = "s", col = "size", desc = "by size" },
}) do
    keymaps["," .. opts.key] = {
        "actions.change_sort",
        opts = { sort = { { "type", "asc" }, { opts.col, "asc" } } },
        desc = "Sort " .. opts.desc,
    }
    keymaps["," .. opts.key:upper()] = {
        "actions.change_sort",
        opts = { sort = { { "type", "asc" }, { opts.col, "desc" } } },
        desc = "Sort " .. opts.desc .. " (reversed)",
    }
end

-- Copy keys, similar to yazi but adapted to nvim
local function copy_action(opts)
    -- Adapted from the default yamk_entry, except it copy to "+ instead
    opts = opts or {}
    local oil = require("oil")
    local entry = oil.get_cursor_entry()
    local dir = oil.get_current_dir()
    if not entry or not dir then return end
    local name = entry.name
    if entry.type == "directory" then name = name .. "/" end
    local path = dir .. name
    path = vim.fn.fnamemodify(path, opts.modify)
    vim.fn.setreg("+", path)
end

for _, opts in ipairs({
    { key = "c", modify = ":~:.", desc = "filepath (relative)" },
    { key = "C", modify = ":p:~", desc = "filepath (absolute)" },
    { key = "n", modify = ":t:r", desc = "filename without extension" },
    { key = "d", modify = ":~:.:h", desc = "directory (relative)" },
    { key = "D", modify = ":p:h", desc = "directory (absolute)" },
    { key = "f", modify = ":t", desc = "filename" },
}) do
    keymaps["gc" .. opts.key] = {
        copy_action,
        opts = { modify = opts.modify },
        desc = "Yank " .. opts.desc,
    }
end

---@class OpenOpts
---@field swap   boolean?

---@param dir?  string
---@param opts? OpenOpts
local function open(dir, opts)
    opts = opts or {}

    local oil = require("oil")

    local f = oil.open_float
    if opts.swap then f = oil.open end

    f(dir, {}, function()
        vim.schedule(function()
            vim.wo.winblend = 15
            oil.open_preview()
        end)
    end)
end

vim.api.nvim_create_user_command("Dir", function(args)
    local dir = nil
    ---@type OpenOpts
    local opts = {}

    for _, arg in ipairs(args.fargs) do
        if arg == "--swap" then
            opts.swap = true
        elseif arg:sub(1, 1) == "-" then
            error("Invalid option: " .. arg)
        elseif dir then
            error("Too many arguments: " .. arg)
        else
            dir = arg
        end
    end

    open(dir, opts)
end, {
    desc = "Open file explorer in directory (Oil)",
    complete = "dir",
    nargs = "*",
})

vim.api.nvim_create_user_command("Open", function(args)
    vim.cmd.tabnew()
    vim.cmd.tcd(args.fargs[1])
    open(nil, { swap = true })
end, {
    desc = "Open directory in new tab",
    complete = "dir",
    nargs = 1,
})

vim.api.nvim_create_user_command("Settings", "Open ~/Settings", {
    desc = "Open Settings directory",
})

-- Disable blend for the icons so they are double width no matter the winblend
if vim.fn.has("gui_running") == 0 then
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
        pattern = "oil",
        callback = function()
            for _, hl in ipairs({
                "MiniIconsAzure",
                "MiniIconsBlue",
                "MiniIconsCyan",
                "MiniIconsGreen",
                "MiniIconsGrey",
                "MiniIconsOrange",
                "MiniIconsPurple",
                "MiniIconsRed",
                "MiniIconsYellow",
            }) do
                vim.api.nvim_set_hl(0, hl, { blend = 0, update = true })
            end
        end,
    })
end

---@type LazySpec[]
return {
    {
        --"stevearc/oil.nvim",
        "FelipeSharkao/oil.nvim",
        branch = "fix/632", -- I'm waiting on https://github.com/stevearc/oil.nvim/pull/769
        lazy = false,
        opts = {
            columns = { "icon", "size" },
            constrain_cursor = "name",
            default_file_explorer = true,
            delete_to_trash = true,
            float = { padding = 3, border = "rounded" },
            keymaps = keymaps,
            cleanup_delay_ms = 0, -- this was crashing when closing and opening
            preview_win = {
                win_options = {
                    foldenable = false,
                    foldmethod = "manual",
                    foldlevel = 999,
                },
            },
            skip_confirm_for_simple_edits = true,
            watch_for_changes = true,
            win_options = {
                winblend = 15,
                signcolumn = "yes:2",
            },
        },
        keys = {
            {
                "gfe",
                open,
                desc = "Show the current file in the file browser",
            },
        },
    },
    {
        "refractalize/oil-git-status.nvim",
        dependencies = {
            {
                --"stevearc/oil.nvim",
                "FelipeSharkao/oil.nvim",
                branch = "fix/632", -- I'm waiting on https://github.com/stevearc/oil.nvim/pull/769
            },
        },
        opts = {},
    },
}
