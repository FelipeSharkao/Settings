local opts = { noremap = true, silent = true }

vim.g.AutoPairsMultilineClose = false
vim.g.AutoPairsMapCh = false

vim.g.AutoPairsShortcutBackInsert = "<C-U>"

vim.g.AutoPairsShortcutFastWrap = "<Nop>"
vim.g.AutoPairsShortcutToggle = "<Nop>"
vim.g.AutoPairsShortcutDelete = "<Nop>"
vim.g.AutoPairsShortcutFastWrap = "<Nop>"
vim.g.AutoPairsShortcutJump = "<Nop>"

vim.g.AutoPairsMoveCharacter = ""

local go_to_opening = function(char)
	return "<C-O>" .. "[" .. char
end

local go_to_closing = function(char)
	return "<C-O>" .. "]" .. char .. "<Right>"
end

vim.api.nvim_set_keymap("i", "<C-F>[", go_to_opening("["), opts)
vim.api.nvim_set_keymap("i", "<C-F>]", go_to_closing("]"), opts)
vim.api.nvim_set_keymap("i", "<C-F>{", go_to_opening("{"), opts)
vim.api.nvim_set_keymap("i", "<C-F>}", go_to_closing("}"), opts)
vim.api.nvim_set_keymap("i", "<C-F>(", go_to_opening("("), opts)
vim.api.nvim_set_keymap("i", "<C-F>)", go_to_closing(")"), opts)
