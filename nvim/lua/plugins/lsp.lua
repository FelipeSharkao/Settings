local function setup_servers()
    local utils = require("plugin-utils")

    vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(client, bufnr) utils.lsp.enable_inlay_hints(client, bufnr) end,
    })

    local no_format = {
        "gdscript",
        "vtsls",
        "dockerls",
        "ocamllsp",
        "sourcekit",
        "lua_ls",
        "eslint",
        "graphql",
    }
    for _, server in ipairs(no_format) do
        vim.lsp.config(server, {
            on_attach = utils.lsp.extend_on_attach(server, function(client)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end),
        })
    end

    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", pathStrict = false },
            },
        },
    })

    local js_lang_settings = {
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

    vim.lsp.config("vtsls", {
        settings = {
            publish_diagnostic_on = "insert_leave",
            typescript = js_lang_settings,
            javascript = js_lang_settings,
            vtsls = { experimental = { entriesLimit = 30 } },
        },
    })

    vim.lsp.config("rust_analyzer", {
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

    vim.lsp.config("sourcekit", {
        capabilities = {
            workspace = {
                didChangeWatchedFiles = {
                    dynamicRegistration = true,
                },
            },
        },
    })

    local gdscript_port = os.getenv("GDScript_Port") or "6005"

    vim.lsp.config("gdscript", {
        cmd = vim.lsp.rpc.connect("127.0.0.1", tonumber(gdscript_port)),
        filetypes = { "gd", "gdscript", "gdscript3" },
        root_markers = { "project.godot", ".git" },
    })
end

---@type LazySpec[]
return {
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        config = function()
            setup_servers()

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
                    "clangd",
                    "elp", -- erlang
                },
            })

            vim.lsp.enable("ocamllsp", true)
            vim.lsp.enable("gdscript", true)
            vim.lsp.enable("sourcekit", true)
        end,
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
            { "grt", vim.lsp.buf.type_definition, mode = "n" },
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
                    ensure_installed = {
                        "stylua",
                        "prettierd",
                        "gdtoolkit",
                        "swiftformat",
                    },
                    automatic_installation = false,
                    handlers = {},
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
                    null_ls.builtins.formatting.gdformat,
                    null_ls.builtins.diagnostics.gdlint,
                    null_ls.builtins.diagnostics.tidy,
                    null_ls.builtins.formatting.tidy.with({
                        args = function(params)
                            local args = { "-indent", "-wrap", "-quiet" }
                            local ft = vim.api.nvim_get_option_value(
                                "filetype",
                                { buf = params.bufnr }
                            )
                            if ft == "xml" then table.insert(args, "-xml") end
                            table.insert(args, "-")
                            return args
                        end,
                    }),
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
            autoEnableHints = false,
        },
    },
    { "folke/lazydev.nvim", opts = {} },
}
