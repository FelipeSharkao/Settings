local null_ls = require("null-ls")
local inlay_hints = require("lsp-inlayhints")

local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }

local keymap = vim.keymap.set

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
        "eslint",
        "lua_ls",
        "rust_analyzer",
        "taplo",
        "astro",
        "zls",
        "dockerls",
        "svelte",
        "graphql",
    },
})
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd.with({
            extra_filetypes = { "astro" },
        }),
        null_ls.builtins.formatting.stylua,
    },
    on_attach = function(client, bufnr)
        on_attach_formatter(client, bufnr)
    end,
})
require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = true,
})
require("mason-nvim-dap").setup({
    ensure_installed = { "node2" },
})

inlay_hints.setup()

keymap("i", "<Tab>", "pumvisible() ? '<C-n>' : '<Tab>'", xopts)
keymap("n", "<Leader>q", vim.diagnostic.setloclist, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, opts)
keymap("n", "]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, opts)
keymap("n", "[w", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, opts)
keymap("n", "]w", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, opts)
keymap("n", "gD", function()
    vim.diagnostic.open_float({ scope = "line" })
end, opts)
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "gi", vim.lsp.buf.references, opts)
keymap("n", "gI", vim.lsp.buf.implementation, opts)
keymap("n", "gt", vim.lsp.buf.type_definition, opts)
keymap("n", "gh", vim.lsp.buf.hover, opts)
keymap("n", "gH", vim.lsp.buf.signature_help, opts)
keymap("i", "<C-h>", vim.lsp.buf.signature_help, opts)
keymap("n", "gr", vim.lsp.buf.rename, opts)
keymap("n", "ga", vim.lsp.buf.code_action, opts)
keymap("n", "gf", function()
    vim.lsp.buf.format({ async = true })
end, opts)
keymap("v", "gf", function()
    vim.lsp.buf.format({
        async = true,
        range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
    })
end, opts)

local lspconfig = require("lspconfig")

local auto_format_augroup =
    vim.api.nvim_create_augroup("Format on save", { clear = true })
local function on_attach_formatter(_, bufnr)
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        buffer = bufnr,
        group = auto_format_augroup,
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })
end

local on_attach = function(client, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
    -- Use internal formatting for bindings like gq
    vim.api.nvim_set_option_value("formatexpr", "", { buf = bufnr })

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
        require("nvim-navbuddy").attach(client, bufnr)
    end

    inlay_hints.on_attach(client, bufnr)

    if client.server_capabilities.documentFormattingProvider then
        on_attach_formatter(client, bufnr)
    end
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
lspconfig.eslint.setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
})
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = { enable = true },
            },
            procMacro = {
                enable = true,
            },
            rustfmt = {
                extraArgs = { "+nightly" },
            },
        },
    },
})
lspconfig.taplo.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.lua_ls.setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
})
lspconfig.svelte.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.astro.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.zls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.dockerls.setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
})
lspconfig.graphql.setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
    end,
})
