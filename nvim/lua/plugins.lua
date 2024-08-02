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
    -- ====== UI and visuals ======

    -- show indentation levels
    "lukas-reineke/indent-blankline.nvim",

    -- Notifications
    {
        "j-hui/fidget.nvim",
        opts = { progress = { lsp = { progress_ringbuf_size = 1024 } } },
        event = "BufEnter",
    },

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
    -- LSP and linters
    "folke/lsp-colors.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "jay-babu/mason-null-ls.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "nvimtools/none-ls.nvim", -- replaces jose-elias-alvarez/null-ls.nvim
    "lvimuser/lsp-inlayhints.nvim",

    -- Debugging
    "mfussenegger/nvim-dap",
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },

    -- Suggestions and completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-vsnip",
            "onsails/lspkind.nvim",
        },
    },
    "hrsh7th/vim-vsnip",
    "hrsh7th/vim-vsnip-integ",

    -- Breadcrumbs winbar
    {
        "Bekaboo/dropbar.nvim",
        dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
        opts = {},
        event = { "BufEnter" },
        keys = {
            {
                mode = "n",
                "<Leader>c",
                function()
                    require("dropbar.api").pick()
                end,
            },
            {
                mode = "n",
                "[c",
                function()
                    require("dropbar.api").goto_context_start()
                end,
            },
        },
    },

    -- Auto-detect identation
    "tpope/vim-sleuth",

    -- better highlighting
    { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
    "evanleck/vim-svelte",
    "preservim/vim-markdown",
    {
        "wuelnerdotexe/vim-astro",
        init = function()
            vim.g.astro_typescript = "enable"
        end,
    },

    -- Preview CSS colors
    {
        "NvChad/nvim-colorizer.lua",
        opts = { user_default_options = { css = true, tailwind = true } },
        event = { event = "BufEnter", pattern = { "*.css", "*.scss", "*.jsx", "*.tsx" } },
    },

    -- ====== File and project management ======
    -- close buffer without closing window
    "moll/vim-bbye",

    -- telescope - searching / navigation
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-dap.nvim",
        },
    },

    -- File explorer as a buffer
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            experimental_watch_for_changes = true,
            keymaps = {
                ["<C-q>"] = "actions.close",
                ["q"] = "actions.close",
                ["<BS>"] = "actions.parent",
                ["<C-h>"] = "actions.toggle_hidden",
                ["<C-l>"] = "action.send_to_qflist",
                ["="] = {
                    mode = "n",
                    callback = function()
                        require("oil").save()
                    end,
                },
            },
        },
        keys = {
            {
                "<Leader>e",
                "<Cmd>Oil<CR>",
                mode = { "n" },
            },
        },
    },

    -- ====== Movement and editing ======
    {
        "haya14busa/vim-asterisk",
        lazy = true,
        config = function()
            vim.g["asterisk#keeppos"] = true
        end,
        keys = {
            { "*", "<Plug>(asterisk-z*)", mode = { "n", "v" } },
            { "#", "<Plug>(asterisk-z#)", mode = { "n", "v" } },
            { "g*", "<Plug>(asterisk-gz*)", mode = { "n", "v" } },
            { "g#", "<Plug>(asterisk-gz#)", mode = { "n", "v" } },
        },
    },
    {
        "tpope/vim-abolish",
        lazy = true,
        cmd = { "Subvert", "S", "Abolish" },
    },

    -- ====== Integration ======
    -- -- Github Copilot
    -- {
    --     "zbirenbaum/copilot.lua",
    --     lazy = true,
    --     cmd = "Copilot",
    --     event = "InsertEnter",
    --     opts = {
    --         suggestion = {
    --             auto_trigger = true,
    --             keymap = {
    --                 accept_line = "<Right>",
    --             },
    --         },
    --     },
    -- },

    -- Connect to Discord's RPC
    "andweeb/presence.nvim",

    -- Respect .editorconfig file
    "gpanders/editorconfig.nvim",

    -- Git
    "lewis6991/gitsigns.nvim",
    "sindrets/diffview.nvim",
    { "APZelos/blamer.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

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
})
