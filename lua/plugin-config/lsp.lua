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
    ensure_installed = {
        "prismals",
        "lua_ls",
        "rust_analyzer",
        "astro",
    },
})

inlay_hints.setup()

keymap("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", xopts)
keymap("n", "<Leader>e", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<Leader>q", vim.diagnostic.setloclist, opts)
keymap("n", "gd", telescope.lsp_definitions, opts)
keymap("n", "gi", telescope.lsp_references, opts)
keymap("n", "gI", telescope.lsp_implementations, opts)
keymap("n", "gt", telescope.lsp_type_definitions, opts)
keymap("n", "gh", vim.lsp.buf.hover, opts)
keymap("n", "gr", vim.lsp.buf.rename, opts)
keymap("n", "ga", vim.lsp.buf.code_action, opts)
keymap("n", "gk", vim.lsp.buf.signature_help, opts)
keymap("i", "<C-K>", vim.lsp.buf.signature_help, opts)
keymap("n", "ge", vim.diagnostic.open_float, opts)
keymap("n", "[e", vim.diagnostic.goto_prev, opts)
keymap("n", "]e", vim.diagnostic.goto_next, opts)
keymap("n", "gf", function()
    vim.lsp.buf.format({ async = true })
end, opts)

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    inlay_hints.on_attach(client, bufnr)
end

local on_attach_no_format = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    on_attach(client, bufnr)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("typescript-tools").setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
    settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        tsserver_plugins = {},
        tsserver_file_preferences = {
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
        },
    },
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
lspconfig.lua_ls.setup({
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
lspconfig.astro.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.formatting.prettierd.with({
            {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "vue",
                "css",
                "scss",
                "less",
                "html",
                "json",
                "jsonc",
                "yaml",
                "markdown",
                "markdown.mdx",
                "graphql",
                "handlebars",
                "astro",
            },
        }),
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.prismaFmt,
        null_ls.builtins.formatting.taplo,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.fnlfmt,
    },
})
require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = true,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.lsp.buf.format({ async = false, silent = true })
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
    end,
})
