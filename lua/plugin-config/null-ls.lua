local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.prismaFmt,
		null_ls.builtins.formatting.taplo,
		null_ls.builtins.formatting.stylua,
	},
})

vim.api.nvim_create_autocmd("BufWritePre *", {
	callback = function()
		vim.lsp.buf.formatting_sync()
	end,
})
