local telescope = require("telescope.builtin")
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local inlay_hints = require("lsp-inlayhints")

local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }

local keymap = vim.keymap.set

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

inlay_hints.setup()

keymap("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", xopts)
keymap("n", "<Leader>e", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<Leader>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Support for inlay hints
    -- see https://github.com/neovim/neovim/issues/18086
    inlay_hints.on_attach(client, bufnr)

    local bopts = { noremap = true, silent = true, buffer = bufnr }
    keymap("n", "gd", telescope.lsp_definitions, bopts)
    keymap("n", "gi", telescope.lsp_references, bopts)
    keymap("n", "gI", telescope.lsp_implementations, bopts)
    keymap("n", "gt", telescope.lsp_type_definitions, bopts)
    keymap("n", "gh", vim.lsp.buf.hover, bopts)
    keymap("n", "gr", vim.lsp.buf.rename, bopts)
    keymap("n", "ga", vim.lsp.buf.code_action, bopts)
    keymap("n", "gk", vim.lsp.buf.signature_help, bopts)
    keymap("i", "<C-K>", vim.lsp.buf.signature_help, bopts)
    keymap("n", "ge", vim.diagnostic.open_float, bopts)
    keymap("n", "[e", vim.diagnostic.goto_prev, bopts)
    keymap("n", "]e", vim.diagnostic.goto_next, bopts)
    keymap("n", "gf", function()
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
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
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
        vim.lsp.buf.format({ async = false, silent = true })
    end,
})
