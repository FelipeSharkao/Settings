local utils = require("plugin-utils")

-- install lazy.nvim if it's not installed already
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins" },

        -- ====== UI and visuals ======

        -- show indentation levels
        "lukas-reineke/indent-blankline.nvim",

        -- Notifications
        { "j-hui/fidget.nvim", opts = {}, event = "BufEnter" },

        -- vim.ui.select
        {
            "stevearc/dressing.nvim",
            opts = {
                input = {
                    mappings = {
                        n = {
                            ["q"] = "Close",
                        },
                    },
                },
                select = {
                    backend = "builtin",
                    builtin = {
                        max_height = 0.8,
                        mappings = {
                            ["q"] = "Close",
                        },
                    },
                    get_config = function(opts)
                        if opts.kind == "codeaction" then
                            return {
                                builtin = {
                                    show_numbers = true,
                                    relative = "cursor",
                                    border = "solid",
                                    max_width = 40,
                                },
                            }
                        end
                    end,
                },
            },
        },

        -- ====== Language features ======
        -- Breadcrumbs and navigation
        {
            "SmiteshP/nvim-navic",
            opts = {
                icons = utils.lsp_icons,
                lsp = { auto_attach = true },
            },
            init = function()
                vim.o.winbar = " %{%v:lua.require('plugin-utils').winbar_get_icon()%}"
                    .. " %{%v:lua.require('nvim-navic').get_location()%}"
            end,
        },

        -- Auto-detect indentation
        "tpope/vim-sleuth",

        -- better highlighting
        { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
        "evanleck/vim-svelte",
        "preservim/vim-markdown",
        {
            "wuelnerdotexe/vim-astro",
            init = function() vim.g.astro_typescript = "enable" end,
        },

        -- Preview CSS colors
        {
            "NvChad/nvim-colorizer.lua",
            opts = { user_default_options = { css = true, tailwind = true } },
            event = {
                event = "BufEnter",
                pattern = { "*.css", "*.scss", "*.jsx", "*.tsx" },
            },
        },

        -- ====== File and project management ======
        -- telescope - searching / navigation
        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
                "nvim-telescope/telescope-dap.nvim",
            },
        },

        -- ====== Movement and editing ======
        {
            "haya14busa/vim-asterisk",
            lazy = true,
            config = function() vim.g["asterisk#keeppos"] = true end,
            keys = {
                { "*", "<Plug>(asterisk-z*)", mode = { "n", "v" } },
                { "#", "<Plug>(asterisk-z#)", mode = { "n", "v" } },
                { "g*", "<Plug>(asterisk-gz*)", mode = { "n", "v" } },
                { "g#", "<Plug>(asterisk-gz#)", mode = { "n", "v" } },
            },
        },
        -- Change case
        {
            "johmsalas/text-case.nvim",
            dependencies = { "nvim-telescope/telescope.nvim" },
            lazy = true,
            config = function()
                require("textcase").setup({ prefix = "gc" })
                require("telescope").load_extension("textcase")
            end,
            cmd = { "Subs", "TextCaseOpenTelescope" },
            keys = {
                "gt",
                {
                    "<Leader>t",
                    "<Cmd>TextCaseOpenTelescope<CR>",
                    mode = { "n", "x" },
                    desc = "text-case Telescope",
                },
            },
        },
        -- commenstring in jsx
        {
            "JoosepAlviste/nvim-ts-context-commentstring",
            opts = { enable_autocmd = false },
            init = function()
                local get_option = vim.filetype.get_option
                vim.filetype.get_option = function(filetype, option)
                    if option == "commentstring" then
                        return require("ts_context_commentstring.internal").calculate_commentstring()
                    end
                    return get_option(filetype, option)
                end
            end,
        },

        -- ====== Integration ======
        -- Connect to Discord's RPC
        "andweeb/presence.nvim",

        -- Respect .editorconfig file
        "gpanders/editorconfig.nvim",

        -- Git
        "lewis6991/gitsigns.nvim",
        "sindrets/diffview.nvim",
        {
            "APZelos/blamer.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },

        -- ====== Misc ======
        -- many, many features
        {
            "echasnovski/mini.nvim",
            dependencies = { "lewis6991/gitsigns.nvim" },
        },

        -- Remember last colorscheme
        {
            "raddari/last-color.nvim",
            init = function()
                local theme = require("last-color").recall() or "wal"
                vim.cmd("colorscheme " .. theme)
            end,
        },
    },
})
