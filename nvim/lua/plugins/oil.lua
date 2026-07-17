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

-- Yank keys, similar to yazi but adapted to nvim
for _, opts in ipairs({
    { key = "y", modify = ":~:.", desc = "filepath (relative)" },
    { key = "Y", modify = ":p:~", desc = "filepath (absolute)" },
    { key = "n", modify = ":t:r", desc = "filename without extension" },
    { key = "d", modify = ":~:.:h", desc = "directory (relative)" },
    { key = "d", modify = ":p:h", desc = "directory (absolute)" },
    { key = "f", modify = ":t", desc = "filename" },
}) do
    keymaps["gy" .. opts.key] = {
        "actions.yank_entry",
        opts = { modify = ":~" .. (opts.rel and ":." or "") .. opts.modify },
        desc = "Yank " .. opts.desc .. (opts.rel and " (relative)" or ""),
    }
    if opts.rel then
        keymaps["gy" .. opts.key:upper()] = {
            "actions.yank_entry",
            opts = { modify = ":p:~" .. opts.modify },
            desc = "Yank " .. opts.desc .. " (absolute)",
        }
    end
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
    vim.cmd.cd(args.fargs[1])
    open(nil, { swap = true })
end, {
    desc = "Open directory in new tab",
    complete = "dir",
    nargs = 1,
})

vim.api.nvim_create_user_command("Settings", "Open ~/Settings", {
    desc = "Open Settings directory",
})

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
