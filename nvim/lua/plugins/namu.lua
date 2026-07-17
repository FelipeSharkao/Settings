require("lazy")

local augroup = vim.api.nvim_create_augroup("namu-config", { clear = true })

---@class Key: vim.keymap.set.Opts
---@field [1] string lhs
---@field [2] string rhs

---@type Key[]
local keys = {
    {
        "gss",
        "<Cmd>Namu symbols<CR>",
        desc = "Jump to LSP symbol",
    },
    {
        "gsw",
        "<Cmd>Namu workspace<CR>",
        desc = "LSP Symbols - Workspace",
    },
    {
        "gsd",
        "<Cmd>Namu diagnostics workspace<CR>",
        desc = "LSP Diagnostics - Workspace",
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    group = augroup,
    callback = function(args)
        if args.match == "oil" then return end
        for _, key in ipairs(keys) do
            local opts = vim.tbl_extend("force", key, { buf = args.buf })
            vim.keymap.set("n", table.remove(opts, 1), table.remove(opts, 1), opts)
        end
    end,
})

---@type LazySpec[]
return {
    {
        "bassamsdata/namu.nvim",
        lazy = false,
        opts = {
            global = {
                movement = {
                    next = { "<C-n>", "<C-j>" },
                    previous = { "<C-p>", "<C-k>" },
                    close = { "<Esc>" },
                    select = { "<CR>", "<C-i>" },
                },
                display = { format = "tree_guides" },
            },
            namu_symbols = { enable = true },
            workspace = { enable = true },
            ui_select = { enable = true },
        },
    },
}
