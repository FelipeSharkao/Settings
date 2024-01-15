local null_ls = require("null-ls")
local inlay_hints = require("lsp-inlayhints")

local lsputil_code_action = require("lsputil.codeAction")
local lsputil_locations = require("lsputil.locations")
local lsputil_symbols = require("lsputil.symbols")

local navbuddy = require("nvim-navbuddy")

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
        "vtsls",
        "lua_ls",
        "rust_analyzer",
        "astro",
    },
})

inlay_hints.setup()

navbuddy.setup({
    window = { border = "rounded" },
})

vim.lsp.handlers["textDocument/codeAction"] = lsputil_code_action.code_action_handler
vim.lsp.handlers["textDocument/references"] = lsputil_locations.references_handler
vim.lsp.handlers["textDocument/definition"] = lsputil_locations.definition_handler
vim.lsp.handlers["textDocument/declaration"] = lsputil_locations.declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = lsputil_locations.typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = lsputil_locations.implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = lsputil_symbols.document_handler
vim.lsp.handlers["workspace/symbol"] = lsputil_symbols.workspace_handler

vim.g.lsp_utils_location_opts = {
    height = 24,
    list = {
        border = false,
        numbering = false,
        highlight = "Normal",
        selection_highlight = "Visual",
        matching_highlight = "Identifier",
    },
    preview = {
        border = false,
        highlight = "Normal",
        preview_highlight = "Visual",
    },
}

keymap("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", xopts)
keymap("n", "<Leader>q", vim.diagnostic.setloclist, opts)
keymap("n", "<Leader>t", navbuddy.open, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "[e", vim.diagnostic.goto_prev, opts)
keymap("n", "]e", vim.diagnostic.goto_next, opts)
keymap("n", "gD", vim.diagnostic.open_float, opts)
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "gi", vim.lsp.buf.references, opts)
keymap("n", "gI", vim.lsp.buf.implementation, opts)
keymap("n", "gt", vim.lsp.buf.type_definition, opts)
keymap("n", "gh", vim.lsp.buf.hover, opts)
keymap("n", "gH", vim.lsp.buf.signature_help, opts)
keymap("n", "gr", vim.lsp.buf.rename, opts)
keymap("n", "ga", vim.lsp.buf.code_action, opts)
keymap("n", "gf", function()
    vim.lsp.buf.format({ async = true })
end, opts)

local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    inlay_hints.on_attach(client, bufnr)
    navbuddy.attach(client, bufnr)

    -- Use internal formatting for bindings like gq
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "")
end

local on_attach_no_format = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    on_attach(client, bufnr)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local vtsls_lang_settings = {
    inlayHints = {
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
    },
    preferences = {
        preferTypeOnlyAutoImports = true,
    },
}

lspconfig.vtsls.setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
    settings = {
        publish_diagnostic_on = "insert_leave",
        typescript = vtsls_lang_settings,
        javascript = vtsls_lang_settings,
        vtsls = { experimental = { entriesLimit = 30 } },
    },
})
lspconfig.rust_analyzer.setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            cargo = { buildScripts = { enable = true } },
            procMacro = { enable = true },
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
