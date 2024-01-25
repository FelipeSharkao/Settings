local leader = ";"
vim.g.mapleader = leader

-- defaults
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }

-- disable leader action
keymap("n", leader, "<NOP>", opts)

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

-- make the cursor stay on the same character when leaving insert mode
keymap("i", "jj", "<Esc>", opts)
-- use Esc in terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
-- use Esc to cancel search
keymap("n", "<Esc>", "<Cmd>noh<CR>", opts)

-- stay in normal mode after inserting a new line
keymap("n", "o", "o <BS><Esc>", opts)
keymap("n", "O", "O <BS><Esc>", opts)

-- create a new line without breaking the current one
keymap("i", "<C-CR>", "<C-O>o", opts)
keymap("i", "<C-S-CR>", "<C-O>O", opts)

-- Mapping Del and Backspace
keymap("n", "<Del>", "dl", opts)
keymap("n", "<BS>", "dh", opts)
keymap("i", "<C-Del>", '<C-O>"_de', opts)
keymap("i", "<C-BS>", '<Esc>"_db"dli', opts)

-- Mapping U to Redo.
keymap("n", "U", "<C-R>", opts)

-- CTRL-s to save
keymap("n", "<C-S>", "<Cmd>w<CR>", opts)
keymap("n", "<Leader><C-S>", "<Cmd>wall<CR>", opts)
keymap("i", "<C-S>", "<Esc><Cmd>w<CR>", opts)

-- indent via Tab
keymap("n", "<Tab>", ">>_", opts)
keymap("v", "<Tab>", ">_", opts)
keymap("n", "<S-Tab>", "<<_", opts)
keymap("i", "<S-Tab>", "<C-O><<<C-O>_", opts)
keymap("v", "<S-Tab>", "<_", opts)

-- go to next/previous buffer
keymap("n", "[b", "<Cmd>edit #<CR>", opts)
keymap("n", "]b", "<Cmd>bnext<CR>", opts)

-- CTRL-v to paste
keymap({ "i", "c" }, "<C-V>", '<C-R><C-O>"', opts)
keymap("t", "<C-V>", "<C-\\><C-O>gp", opts)
