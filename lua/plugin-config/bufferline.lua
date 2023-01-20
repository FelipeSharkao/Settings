local opts = { noremap = true, silent = true }

require("bufferline").setup({
	options = {
		close_command = "confirm bdelete %d",
		right_mouse_command = "confirm bdelete %d",
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		separator_style = "slant",
		show_duplicated_prefix = true,
		max_name_length = 99,
		max_prefix_length = 99,
	},
	highlights = function()
		local bg = "#292D38"
		return {
			fill = { bg = bg },
			separator = { fg = bg },
			separator_visible = { fg = bg },
			separator_selected = { fg = bg },
		}
	end,
})

vim.api.nvim_create_user_command("BufCloseAllButCurrent", function()
	local current = vim.api.nvim_get_current_buf()
	for i, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
			vim.cmd("confirm bdelete " .. buf)
		end
	end
end, { nargs = 0 })

vim.api.nvim_create_user_command("BufCloseAllRight", function()
	local current = vim.api.nvim_get_current_buf()
	for i, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf > current and vim.api.nvim_buf_is_loaded(buf) then
			vim.cmd("confirm bdelete " .. buf)
		end
	end
end, { nargs = 0 })

vim.api.nvim_create_user_command("BufCloseAllLeft", function()
	local current = vim.api.nvim_get_current_buf()
	for i, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf < current and vim.api.nvim_buf_is_loaded(buf) then
			vim.cmd("confirm bdelete " .. buf)
		end
	end
end, { nargs = 0 })

vim.api.nvim_set_keymap("n", "fj", "<Cmd>bprevious<CR>", opts)
vim.api.nvim_set_keymap("n", "fk", "<Cmd>bnext<CR>", opts)
vim.api.nvim_set_keymap("n", "fh", "<Cmd>bfirst<CR>", opts)
vim.api.nvim_set_keymap("n", "fl", "<Cmd>blast<CR>", opts)
vim.api.nvim_set_keymap("n", "fx", "<Cmd>confirm bdelete %<CR>", opts)
vim.api.nvim_set_keymap("n", "fX", "<Cmd>BufCloseAllButCurrent<CR>", opts)
