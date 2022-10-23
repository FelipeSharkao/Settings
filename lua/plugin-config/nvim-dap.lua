local dap = require("dap")
local opts = { silent = true, noremap = true }

require("dap-vscode-js").setup({
	debugger_path = "/home/felipe/.dev/vscode-js-debug",
	adapters = { "pwa-node", "pwa-chrome" },
})

for _, language in ipairs({ "typescript", "javascript" }) do
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
	}
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

vim.api.nvim_create_user_command("DebugAttach", function(opts)
	print("Attaching debugger")
	dap.run({
		type = opts.args,
		request = "attach",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		skipFiles = { "<node_internals>/**/*.js" },
	})
end, { nargs = 1 })

vim.api.nvim_create_user_command("DebugBr", function()
	dap.toggle_breakpoint()
end, { nargs = 0 })

vim.api.nvim_set_keymap("n", "<C-d>n", "<Cmd>lua require'dap'.continue()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-d>k", "<Cmd>lua require'dap'.step_out()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-d>j", "<Cmd>lua require'dap'.step_into()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-d>l", "<Cmd>lua require'dap'.step_over()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-d>h", "<Cmd>lua require'dap.ui.variables'.visual_hover()<CR>", opts)
