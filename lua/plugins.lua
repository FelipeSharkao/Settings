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
    -- show recent files on empty nvim command
    "mhinz/vim-startify",

    -- UI framework
    "MunifTanjim/nui.nvim",

    -- Toast notifications
    {
        "rcarriga/nvim-notify",
        init = function()
            require("notify").setup({
                stages = "fade",
                background_colour = "FloatShadow",
                timeout = 3000,
            })
            vim.notify = require("notify")
        end,
    },

    -- Better UI for select actions
    { "stevearc/dressing.nvim", dependencies = { "MunifTanjim/nui.nvim" } },

    -- Scrollbar with code details
    { "petertriho/nvim-scrollbar", dependencies = { "lewis6991/gitsigns.nvim" } },

    -- floating terminal
    "voldikss/vim-floaterm",

    -- prettier tabs
    { "akinsho/bufferline.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

    -- show indentation levels
    "lukas-reineke/indent-blankline.nvim",

    -- improve folding
    "anuvyklack/pretty-fold.nvim",

    -- ====== Language features ======
    -- LSP and linters
    "folke/lsp-colors.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "jay-babu/mason-null-ls.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },

    -- Show LSP inlay hints
    "lvimuser/lsp-inlayhints.nvim",

    -- Debugging
    "mfussenegger/nvim-dap",
    {
        "mxsdev/nvim-dap-vscode-js",
        dependencies = {
            "mfussenegger/nvim-dap",
            {
                "microsoft/vscode-js-debug",
                lazy = true,
                build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
            },
        },
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },

    -- Better suggestions in config files
    "folke/neodev.nvim",

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

    -- preview markdown files
    {
        "iamcco/markdown-preview.nvim",
        build = "cd app && pnpm i",
        init = function()
            vim.g.mkdp_auto_close = false
        end,
        lazy = true,
        ft = "markdown",
    },
    --
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

    -- File tree window
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

    -- project + session management
    "olimorris/persisted.nvim",

    -- ====== Movement and editing ======
    -- Multicursor
    "mg979/vim-visual-multi",

    -- Automaticly close () [] {} '' ""
    "jiangmiao/auto-pairs",

    -- Jump to pattern
    { "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
    "ggandor/flit.nvim",

    -- Indicator for git added and removed lines
    "lewis6991/gitsigns.nvim",

    -- ====== Integration ======
    -- Show commit messages
    {
        "APZelos/blamer.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "akinsho/bufferline.nvim" },
    },

    -- Github Copilot
    "github/copilot.vim",

    -- Connect to Discord's RPC
    "andweeb/presence.nvim",

    -- Respect .editorconfig file
    "gpanders/editorconfig.nvim",

    -- ====== Misc ======
    -- many, many features
    { "echasnovski/mini.nvim", version = false, dependencies = { "lewis6991/gitsigns.nvim" } },

    -- Remember last colorscheme
    "raddari/last-color.nvim",

    -- ====== colorscheme ======
    { "rose-pine/neovim", name = "rose-pine" },
    { "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon" },
    { "folke/tokyonight.nvim", name = "tokyonight" },
    { "catppuccin/nvim", name = "catppuccin" },
})

require("plugin-config/dressing")
require("plugin-config/telescope")
require("plugin-config/nvim-scrollbar")
require("plugin-config/gitsigns")
require("plugin-config/mini")
require("plugin-config/floaterm")
require("plugin-config/lsp")
require("plugin-config/dap")
require("plugin-config/nvim-cmp")
require("plugin-config/nvim-treesitter")
require("plugin-config/persisted")
require("plugin-config/nvim-tree")
require("plugin-config/bufferline")
require("plugin-config/blamer")
require("plugin-config/pretty-fold")
require("plugin-config/copilot")
require("plugin-config/indent-guide-lines")
require("plugin-config/autopairs")
require("plugin-config/leap")
require("plugin-config/discord")
require("plugin-config/theme")
