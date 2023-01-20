if vim.g.neovide then
	vim.opt.guifont = "Monocraft Nerd Font:h10"

	vim.g.neovide_scroll_animation_length = 0.2
	vim.g.neovide_input_use_logo = false
	vim.g.neovide_input_macos_alt_is_meta = true

	-- Paste in insert mode
	vim.api.nvim_set_keymap("i", "<C-V>", '<C-R>"', { noremap = true })
	vim.api.nvim_set_keymap("c", "<C-V>", '<C-R>"', { noremap = true })
	vim.api.nvim_set_keymap("i", "<C-S-V>", "<C-R>+", { noremap = true })
	vim.api.nvim_set_keymap("c", "<C-S-V>", "<C-R>+", { noremap = true })
end
