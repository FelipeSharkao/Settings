---@type LazySpec[]
return {
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        opts = {
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
        },
        keys = {
            {
                "[e",
                function()
                    vim.diagnostic.jump({
                        count = -1,
                        severity = vim.diagnostic.severity.ERROR,
                    })
                end,
                mode = "n",
            },
            {
                "]e",
                function()
                    vim.diagnostic.jump({
                        count = 1,
                        severity = vim.diagnostic.severity.ERROR,
                    })
                end,
                mode = "n",
            },
            { "grt", vim.lsp.buf.type_definition,                         mode = "n" },
            { "grf", function() vim.lsp.buf.format({ async = true }) end, mode = "n" },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },
            {
                "jay-babu/mason-null-ls.nvim",
                opts = {
                    ensure_installed = nil,
                    automatic_installation = true,
                    automatic_setup = true,
                },
            },
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.prettierd.with({
                        extra_filetypes = { "astro" },
                    }),
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.gdformat,
                },
            })

            local auto_format_augroup =
                vim.api.nvim_create_augroup("Format on save", { clear = true })
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                group = auto_format_augroup,
                callback = function() vim.lsp.buf.format({ async = false }) end,
            })
        end,
    },
    {
        "folke/lsp-colors.nvim",
        opts = {
            Error = "#F44747",
            Warning = "#FF8800",
            Hint = "#4FC1FF",
            Information = "#FFCC66",
        },
    },
    {
        "chrisgrieser/nvim-lsp-endhints",
        opts = {
            icons = {
                type = "󰠱 ",
                parameter = "󰀫 ",
                offspec = "󰉿 ",
                unknown = "",
            },
            autoEnableHints = true,
        },
    },
}
