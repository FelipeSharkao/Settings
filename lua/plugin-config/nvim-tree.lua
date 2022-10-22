local opts = { silent = true, noremap = true }
vim.api.nvim_set_keymap("n", "N", "<Cmd>NvimTreeToggle<CR>", opts)

require("nvim-tree").setup({
	disable_netrw = true,
	hijack_cursor = true,
	open_on_setup = true,
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
	},
	view = {
		hide_root_folder = true,
		float = {
			enable = true,
			open_win_config = function()
				local win_h = vim.api.nvim_win_get_height(0)
				local win_w = vim.api.nvim_win_get_width(0)
				local w = 120
				local h = win_h - 10

				return {
					relative = "editor",
					border = "rounded",
					width = w,
					height = h,
					row = (win_h - h) / 2,
					col = (win_w / 2) - (w / 2),
				}
			end,
		},
	},
	render = {
		highlight_git = true,
		highlight_opened_files = "all",
	},
})

require("nvim-web-devicons").setup({
	color_icons = true,
	default = true,
})
