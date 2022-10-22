local leader = ";"
vim.g.mapleader = leader

-- defaults
local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }
local keymap = vim.api.nvim_set_keymap

local esc = '(col(".") == 1 ? "<Esc>" : "<Esc><Right>")'

-- disable leader action
keymap("n", leader, "<NOP>", opts)

-- clipboard
keymap("n", "+", '"+', opts)
keymap("v", "+", '"+', opts)

-- enable word movement in insert mode
keymap("i", "<C-H>", "<C-O>b", opts)
keymap("i", "<C-L>", "<C-O>w", opts)

-- make the cursor stay on the same character when leaving insert mode
keymap("i", "<Esc>", esc, xopts)
keymap("i", "jj", esc, xopts)
-- use Esc in terminal mode
keymap("t", "<Esc>", "<C-\\><C-n>l", opts)
-- use Esc to cancel search
keymap("n", "<Esc>", "<Cmd>noh<CR>", opts)

-- fast scrolling
keymap("n", "J", "9j", opts)
keymap("n", "K", "9k", opts)
keymap("v", "J", "9j", opts)
keymap("v", "K", "9k", opts)

-- stay in normal mode after inserting a new line
keymap("", "o", "o <Bs><Esc>", opts)
keymap("", "O", "O <Bs><Esc>", opts)

-- Mapping Del and Backspace
keymap("n", "<Del>", "dl", opts)
keymap("n", "<BS>", "dh", opts)
keymap("n", "<C-Del>", "dw", opts)
keymap("n", "<C-BS>", "db", opts)
keymap("i", "<C-Del>", "<C-O>dw", opts)
keymap("i", "<C-BS>", "<C-O>db", opts)

-- Mapping U to Redo.
keymap("", "U", "<C-r>", opts)
keymap("", "<C-R>", "<NOP>", opts)

-- CTRL-s to save
keymap("n", "<C-S>", "<Cmd>w<CR>", opts)
keymap("n", "<Leader><C-S>", "<Cmd>wall<CR>", opts)
keymap("i", "<C-S>", esc .. ' . "<Cmd>w<CR>"', xopts)

-- CTRL-q to close
keymap("n", "<C-q>", "<Cmd>confirm qall<CR>", opts)
keymap("i", "<C-q>", esc .. '. "<Cmd>confirm qall<CR>"', xopts)

-- indent via Tab
keymap("n", "<Tab>", ">>_", opts)
keymap("n", "<S-Tab>", "<<_", opts)
keymap("v", "<Tab>", ">>_", opts)
keymap("v", "<S-Tab>", "<<_", opts)
keymap("i", "<Tab>", "\t", opts)
keymap("i", "<S-Tab>", "\b", opts)

-- opening terminal with shortcut
keymap("", "<Leader><CR>", "<Cmd>silent !$TERM &<CR>", opts)

-- jumping back and forth
keymap("", "<C-K>", "<C-O>", opts)
keymap("", "<C-L>", "<C-I>", opts)

-- I misclick Esc all the time
keymap("", "<F1>", "<NOP>", opts)
