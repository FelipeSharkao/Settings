local null_ls = require("null-ls")

local opts = { noremap = true, silent = true }

local keymap = vim.keymap.set

vim.diagnostic.config({
    virtual_text = { source = true },
    update_in_insert = true,
})

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
        "zls",
        "dockerls",
        "svelte",
        "graphql",
        "hls",
    },
})
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd.with({
            extra_filetypes = { "astro" },
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.gdformat,
    },
})
require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = true,
})
require("mason-nvim-dap").setup({
    ensure_installed = { "node2" },
})

require("lsp-endhints").setup({
    icons = {
        type = "󰠱 ",
        parameter = "󰀫 ",
        offspec = "󰉿 ",
        unknown = "",
    },
    autoEnableHints = true,
})

keymap("n", "[e", function()
    vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, opts)
keymap("n", "]e", function()
    vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, opts)
keymap("n", "grt", vim.lsp.buf.type_definition, opts)
keymap("n", "grf", function()
    vim.lsp.buf.format({ async = true })
end, opts)
keymap("v", "grf", function()
    vim.lsp.buf.format({
        async = true,
        range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
    })
end, opts)

local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
        require("nvim-navbuddy").attach(client, bufnr)
    end
end

local on_attach_no_format = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    on_attach(client, bufnr)
end

local auto_format_augroup =
    vim.api.nvim_create_augroup("Format on save", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = auto_format_augroup,
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

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
lspconfig.hls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})
lspconfig.gdscript.setup({
    on_attach = on_attach_no_format,
    capabilities = capabilities,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
    end,
})
