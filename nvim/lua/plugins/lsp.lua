local augroup = vim.api.nvim_create_augroup("lsp-config", { clear = true })

---@param language string|string[]
---@param lsp_name string
---@param mason_name? string
local function install_server(language, lsp_name, mason_name)
    mason_name = mason_name or lsp_name

    vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = language,
        callback = function()
            local registry = require("mason-registry")
            local pkg = registry.get_package(mason_name)
            if not pkg then
                vim.notify("Package " .. mason_name .. " not found")
                return
            end
            if pkg:is_installed() then
                vim.lsp.enable(lsp_name, true)
            else
                pkg:install({}, function(success)
                    if success then
                        vim.schedule(function() vim.lsp.enable(lsp_name, true) end)
                    else
                        vim.notify("Failed to install package " .. mason_name)
                    end
                end)
            end
        end,
    })
end

local function setup_servers()
    local utils = require("plugin-utils")

    vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(client, bufnr) utils.lsp.enable_inlay_hints(client, bufnr) end,
    })

    local no_format = {
        "gdscript",
        "tsgo",
        "dockerls",
        "ocamllsp",
        "sourcekit",
        "lua_ls",
        "eslint",
        "graphql",
        "c3_lsp",
        "gleam",
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

    vim.lsp.config("tsgo", {
        settings = {
            typescript = js_lang_settings,
            javascript = js_lang_settings,
        },
        -- tsgo has poor debouncing so we have to do it on our side
        flags = { debounce_text_changes = 500 },
    })

    -- Cap the tsgo process to 3GB of RAM because it's spiking
    local function cap_tsgo()
        vim.system({
            "bash",
            "-c",
            [[
                for pid in $(pgrep -f "tsgo"); do
                    rss=$(ps -o rss= -p "$pid")
                    if [ $rss -gt $((3 * 1024 * 1024)) ]; then
                        kill -9 "$pid"
                    fi
                done
            ]],
        })
        vim.defer_fn(cap_tsgo, 5000)
    end
    vim.defer_fn(cap_tsgo, 1000)

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
        "williamboman/mason.nvim",
        lazy = false,
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()

            setup_servers()

            local js = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "svelte",
            }

            install_server("c", "clangd")
            install_server("c3", "c3_lsp", "c3-lsp")
            install_server("docker", "dockerls", "docker-language-server")
            install_server("erlang", "elp")
            install_server("graphql", "graphql", "graphql-language-service-cli")
            install_server("haskell", "hls", "haskell-language-server")
            install_server(js, "eslint", "eslint-lsp")
            install_server("lua", "lua_ls", "lua-language-server")
            install_server("rust", "rust_analyzer", "rust-analyzer")
            install_server("svelte", "svelte", "svelte-language-server")
            install_server("toml", "taplo")
            install_server("zig", "zls")

            vim.lsp.enable("ocamllsp", true)
            vim.lsp.enable("gdscript", true)
            vim.lsp.enable("sourcekit", true)
            vim.lsp.enable("tsgo", true)
            vim.lsp.enable("gleam", true)
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
                    null_ls.builtins.formatting.erlfmt.with({
                        command = "rebar3",
                        args = { "fmt", "-" },
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
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "/usr/share/hypr/stubs", words = { "hl" } },
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
