require("dressing").setup({
    input = {
        mappings = {
            n = {
                ["<Esc>"] = "Close",
                ["<C-q>"] = "Close",
                ["q"] = "Close",
                ["<CR>"] = "Confirm",
                ["<C-o>"] = "Confirm",
            },
            i = {
                ["<C-q>"] = "Close",
                ["<CR>"] = "Confirm",
                ["<C-o>"] = "Confirm",
                ["<Up>"] = "HistoryPrev",
                ["<Down>"] = "HistoryNext",
            },
        },
    },
    select = {
        backend = { "nui", "builtin" },
    },
})
