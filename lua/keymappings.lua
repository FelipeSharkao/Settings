-- defaults
local opts = { noremap = true, silent = true }

-- enable word movement in insert mode
vim.api.nvim_set_keymap('i', '<C-H>', '<C-O>b', opts)
vim.api.nvim_set_keymap('i', '<C-L>', '<C-O>w', opts)

-- make the cursor stay on the same character when leaving insert mode
vim.api.nvim_set_keymap('i', '<Esc>', '<Esc><Right>', opts)
-- use Esc in terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>l', opts)
-- use Esc to cancel search
vim.api.nvim_set_keymap('n', '<Esc>', '<Cmd>noh<CR>', opts)

-- fast scrolling
vim.api.nvim_set_keymap('n', 'J', '9j', opts)
vim.api.nvim_set_keymap('n', 'K', '9k', opts)
vim.api.nvim_set_keymap('v', 'J', '9j', opts)
vim.api.nvim_set_keymap('v', 'K', '9k', opts)

-- stay in normal mode after inserting a new line
vim.api.nvim_set_keymap('', 'o', 'o <Bs><Esc>', opts)
vim.api.nvim_set_keymap('', 'O', 'O <Bs><Esc>', opts)

-- Mapping Del and Backspace
vim.api.nvim_set_keymap('n', '<Del>', 'dl', opts)
vim.api.nvim_set_keymap('n', '<BS>', 'dh', opts)
vim.api.nvim_set_keymap('n', '<C-Del>', 'dw', opts)
vim.api.nvim_set_keymap('n', '<C-BS>', 'db', opts)
vim.api.nvim_set_keymap('i', '<C-Del>', '<C-O>dw', opts)
vim.api.nvim_set_keymap('i', '<C-BS>', '<C-O>db', opts)

-- Mapping U to Redo.
vim.api.nvim_set_keymap('', 'U', '<C-r>', opts)
vim.api.nvim_set_keymap('', '<C-R>', '<NOP>', opts)

-- CTRL-s to save
vim.api.nvim_set_keymap('n', '<C-S>', '<Cmd>w<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader><C-S>', '<Cmd>wall<CR>', opts)
vim.api.nvim_set_keymap('i', '<C-S>', '<Esc><Right><Cmd>w<CR>', opts)

-- indent via Tab
vim.api.nvim_set_keymap('n', '<Tab>', '>>_', opts)
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<_', opts)
vim.api.nvim_set_keymap('v', '<Tab>', '>>_', opts)
vim.api.nvim_set_keymap('v', '<S-Tab>', '<<_', opts)
vim.api.nvim_set_keymap('i', '<Tab>', '\t', opts)
vim.api.nvim_set_keymap('i', '<S-Tab>', '\b', opts)

-- opening terminal with shortcut
vim.api.nvim_set_keymap('', '<Leader><CR>', '<Cmd>silent !$TERM &<CR>', opts)

-- jumping back and forth
vim.api.nvim_set_keymap('', '<C-K>', '<C-O>', opts)
vim.api.nvim_set_keymap('', '<C-L>', '<C-I>', opts)

-- I misclick Esc all the time
vim.api.nvim_set_keymap('', '<F1>', '<NOP>', opts)
