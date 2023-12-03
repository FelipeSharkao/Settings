require("gitsigns").setup()

vim.g.blamer_enabled = true
vim.g.blamer_delay = 500

require("diffview").setup({
    view = {
        mergetool = { layout = "diff4_mixed" },
    },
})

vim.api.nvim_create_user_command("Git", "FloatermNew --cwd=<buffer> lazygit", {})
