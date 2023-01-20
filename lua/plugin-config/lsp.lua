local telescope = require("telescope.builtin")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }

require("neodev").setup({})

require("lsp-colors").setup({
	Error = "#F44747",
	Warning = "#FF8800",
	Hint = "#4FC1FF",
	Information = "#FFCC66",
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "tsserver", "prismals", "svelte", "sumneko_lua", "rust_analyzer" },
})

vim.api.nvim_set_keymap("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", xopts)
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, opts)

local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", telescope.lsp_definitions, bopts)
	vim.keymap.set("n", "gi", telescope.lsp_references, bopts)
	vim.keymap.set("n", "gI", telescope.lsp_implementations, bopts)
	vim.keymap.set("n", "gt", telescope.lsp_type_definitions, bopts)
	vim.keymap.set("n", "gh", vim.lsp.buf.hover, bopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.rename, bopts)
	vim.keymap.set("n", "ga", vim.lsp.buf.code_action, bopts)
	vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, bopts)
	vim.keymap.set("i", "<C-K>", vim.lsp.buf.signature_help, bopts)
	vim.keymap.set("n", "ge", vim.diagnostic.open_float, bopts)
	vim.keymap.set("n", "gf", function()
		vim.lsp.buf.format({ async = true })
	end, bopts)
end

local on_attach_no_format = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	on_attach(client, bufnr)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.tsserver.setup({
	on_attach = on_attach_no_format,
	capabilities = capabilities,
})
lspconfig.rust_analyzer.setup({
	on_attach = on_attach_no_format,
	capabilities = capabilities,
})
lspconfig.sumneko_lua.setup({
	on_attach = on_attach_no_format,
	capabilities = capabilities,
})
lspconfig.svelte.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
lspconfig.prismals.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.prismaFmt,
		null_ls.builtins.formatting.taplo,
		null_ls.builtins.formatting.stylua,
	},
})
require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
	automatic_setup = false,
})

vim.api.nvim_create_autocmd("BufWritePre *", {
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})
