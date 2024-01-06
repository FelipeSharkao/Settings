local leader = ";"
vim.g.mapleader = leader

-- defaults
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }

local esc = '(col(".") == 1 ? "<Esc>" : "<Esc><Right>")'

-- disable leader action
keymap("n", leader, "<NOP>", opts)

-- clipboard
keymap("n", "+", '"+', opts)
keymap("v", "+", '"+', opts)

-- enable word movement in insert mode
keymap("i", "<C-H>", "<C-O>b", opts)
keymap("i", "<C-Left>", "<C-O>b", opts)
keymap("i", "<C-L>", "<C-O>e<Right>", opts)
keymap("i", "<C-Right>", "<C-O>e<Right>", opts)

-- make the cursor stay on the same character when leaving insert mode
keymap("i", "<Esc>", esc, xopts)
keymap("i", "jj", esc, xopts)
-- use Esc in terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>l", opts)
-- use Esc to cancel search
keymap("n", "<Esc>", "<Cmd>noh<CR>", opts)

-- fast scrolling
keymap("n", "<C-J>", "12jz.", opts)
keymap("n", "<C-K>", "12kz.", opts)

-- scrolling in insert mode
keymap("i", "<C-J>", "<Down>", opts)
keymap("i", "<C-K>", "<Up>", opts)

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
keymap("n", "U", "<C-r>", opts)
keymap("n", "<C-R>", "<NOP>", opts)

-- CTRL-s to save
keymap("n", "<C-S>", "<Cmd>w<CR>", opts)
keymap("n", "<Leader><C-S>", "<Cmd>wall<CR>", opts)
keymap("i", "<C-S>", esc .. ' . "<Cmd>w<CR>"', xopts)

-- indent via Tab
keymap("n", "<Tab>", ">>_", opts)
keymap("v", "<Tab>", ">_", opts)
keymap("n", "<S-Tab>", "<<_", opts)
keymap("i", "<S-Tab>", "<C-O><<<C-O>_", opts)
keymap("v", "<S-Tab>", "<_", opts)

-- go to next/previous buffer
keymap("n", "[b", "<Cmd>edit #<CR>", opts)
keymap("n", "]b", "<Cmd>bnext<CR>", opts)
