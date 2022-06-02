-- tab movement
local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('', 'fj', '<Cmd>BufferPrevious<CR>', opts)
vim.api.nvim_set_keymap('', 'fk', '<Cmd>BufferNext<CR>', opts)
vim.api.nvim_set_keymap('', 'fx', '<Cmd>BufferClose<CR>', opts)
vim.api.nvim_set_keymap('', 'fX', '<Cmd>%bdelete|edit#|bdelete#<CR>', opts)
