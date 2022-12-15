vim.b.copilot_enabled = true
vim.g.copilot_no_tab = true

vim.api.nvim_set_keymap("i", "<Right>", 'copilot#Accept("<Right>")', { noremap = true, silent = true, expr = true })
