require("dressing").setup({
    input = {
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["<C-q>"] = "Close",
                ["<C-w>"] = "Close",
                ["q"] = "Close",
                ["<CR>"] = "Confirm",
                ["<C-o>"] = "Confirm",
            },
            i = {
                ["<C-q>"] = "Close",
                ["<C-w>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<C-o>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
            },
        },
    },
    select = {
        backend = { "nui", "builtin" },
        nui = {
            max_width = 200,
        },
        mappings = {
            ["<C-q>"] = "Close",
            ["<C-w>"] = "Close",
            ["q"] = "Close",
            ["<CR>"] = "Confirm",
            ["<C-o>"] = "Confirm",
        },
    },
})
