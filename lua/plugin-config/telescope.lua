-- Find files using lua fuctions
local opts = { silent = true, noremap = true }
vim.api.nvim_set_keymap("n", "<Leader>f", "<Cmd>lua require'telescope.builtin'.find_files()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>g", "<Cmd>lua require'telescope.builtin'.live_grep()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>lua require'telescope.builtin'.resume()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>p", "<Cmd>lua require'telescope'.extensions.project.project{}<CR>", opts)

local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		-- program to use for searching with its arguments
		find_command = { "rg", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
		prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				prompt_position = "top",
				mirror = true,
				preview_height = 0.5,
			},
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules/.*" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		display_path = true,
		color_devicons = true,
		-- less is bash program for preview file contents
		use_less = true,
		-- use all the colors
		set_env = { ["COLORTERM"] = "truecolor" },
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-l>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["<C-q>"] = actions.close,
				["<CR>"] = function()
					vim.cmd([[:stopinsert]])
					vim.cmd([[call feedkeys("\<CR>")]])
				end,
			},
			n = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-l>"] = actions.smart_send_to_qflist + actions.open_qflist,
				["q"] = actions.close,
			},
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
		project = {
			sync_with_nvim_tree = true,
		},
	},
})

require("telescope").load_extension("project")
