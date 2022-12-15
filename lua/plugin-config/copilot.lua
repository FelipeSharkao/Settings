vim.b.copilot_enabled = true
vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("i", "<S-Tab>", 'copilot#Accept("<S-Tab>")', { noremap = true, silent = true, expr = true })
