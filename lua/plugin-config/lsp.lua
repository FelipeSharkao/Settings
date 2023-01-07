local telescope = require("telescope.builtin")
local lspconfig = require("lspconfig")

local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }

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
	vim.keymap.set("n", "gf", function()
		vim.lsp.buf.formatting()
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
	settings = {
		Lua = { diagnostics = { globals = { "vim", "use" } } },
	},
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
