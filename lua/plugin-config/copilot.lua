vim.b.copilot_enabled = true
vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("i", "<C-E>", 'copilot#Accept("<C-E>")', { noremap = true, silent = true, expr = true })
