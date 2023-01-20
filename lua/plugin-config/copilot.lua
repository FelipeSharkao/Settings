vim.b.copilot_enabled = true
vim.g.copilot_no_tab_map = true
vim.g.copilo_node_commang = "/home/felipe/.asdf/shims/node"

vim.api.nvim_set_keymap("i", "<C-E>", 'copilot#Accept("<C-E>")', { noremap = true, silent = true, expr = true })
