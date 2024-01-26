-- defaults
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- clipboard
keymap("n", "+", '"+', opts)
keymap("v", "+", '"+', opts)

-- enable word movement in insert and command mode
keymap({ "i", "c" }, "<C-H>", "<Left>", opts)
keymap({ "i", "c" }, "<C-J>", "<Down>", opts)
keymap({ "i", "c" }, "<C-K>", "<Up>", opts)
keymap({ "i", "c" }, "<C-L>", "<Right>", opts)
keymap({ "i", "c" }, "<C-B>", "<C-O>b", opts)
keymap({ "i", "c" }, "<C-W>", "<C-O>w", opts)
keymap({ "i", "c" }, "<C-E>", "<C-O>e<Right>", opts)

-- Disable arrow keys (git gut)
local arrow_keys = { "<Up>", "<Down>", "<Left>", "<Right>", "<PageUp>", "<PageDown>" }
for _, key in ipairs(arrow_keys) do
    keymap({ "n", "i", "v" }, key, "<Cmd>echo 'Use k, l, f, t, s, <C-U> or <C-D>'<CR>", opts)
end

-- leave insert mode
keymap("i", "jj", "<Esc>", opts)
-- use Esc in terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
-- use Esc to cancel search
keymap("n", "<Esc>", "<Cmd>noh<CR>", opts)

-- create a new line without breaking the current one
keymap("i", "<C-CR>", "<C-O>o", opts)
keymap("i", "<C-S-CR>", "<C-O>O", opts)

-- Mapping U to Redo.
keymap("n", "U", "<C-R>", opts)

-- CTRL-s to save
keymap("n", "<C-S>", "<Cmd>w<CR>", opts)
keymap("n", "<Leader><C-S>", "<Cmd>wall<CR>", opts)
keymap("i", "<C-S>", "<Esc><Cmd>w<CR>", opts)

-- CTRL-v to paste
keymap({ "i", "c" }, "<C-V>", '<C-R><C-O>"', opts)
keymap("t", "<C-V>", "<C-\\><C-O>gp", opts)
