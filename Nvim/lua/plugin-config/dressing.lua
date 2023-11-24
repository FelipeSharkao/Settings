require("dressing").setup({
    input = {
        max_width = { 140, 0.9 },
        min_width = { 40, 0.2 },
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
        backend = { "builtin" },
        builtin = {
            relative = "cursor",
            max_width = { 140, 0.9 },
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
