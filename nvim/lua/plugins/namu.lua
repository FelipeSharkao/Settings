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
        keys = {
            {
                "gss",
                "<Cmd>Namu symbols<CR>",
                desc = "Jump to LSP symbol",
                mode = "n",
            },
            {
                "gsw",
                "<Cmd>Namu workspace<CR>",
                desc = "LSP Symbols - Workspace",
                mode = "n",
            },
        },
    },
}
