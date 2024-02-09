require("gitsigns").setup()

vim.g.blamer_enabled = true
vim.g.blamer_delay = 500

require("diffview").setup({
    view = {
        mergetool = { layout = "diff4_mixed" },
    },
})
