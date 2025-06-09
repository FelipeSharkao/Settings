local namu_options = {
    movement = {
        next = { "<C-n>", "<C-j>" },
        previous = { "<C-p>", "<C-k>" },
        close = { "<Esc>" },
        select = { "<CR>", "<C-i>" },
    },
}

---@type LazySpec[]
return {
    {
        "bassamsdata/namu.nvim",
        lazy = false,
        opts = {
            namu_symbols = { enable = true, options = namu_options },
            workspace = { enable = true, options = namu_options },
            ui_select = { enable = true, options = namu_options },
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
