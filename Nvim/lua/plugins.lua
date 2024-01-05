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
    -- ====== APIs and libraries ======
    "nvim-lua/plenary.nvim",

    -- ====== UI and visuals ======

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
    "nvimtools/none-ls.nvim", -- replaces jose-elias-alvarez/null-ls.nvim
    {
        "yioneko/nvim-vtsls",
        dependencies = { "neovim/nvim-lspconfig" },
        build = "bun add -g @vtsls/language-server",
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
                build = "npm install && npx gulp vsDebugServerBundle && mv dist out",
            },
        },
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap" } },

    -- Navigate through LSP symbols
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "numToStr/Comment.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },

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

    -- Better UI for LSP actions
    "RishabhRD/popfix",
    "RishabhRD/nvim-lsputils",

    -- Better comments
    { "numToStr/Comment.nvim", opts = {} },

    -- Preview CSS colors
    {
        "NvChad/nvim-colorizer.lua",
        opts = { user_default_options = { css = true, tailwind = true } },
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

    -- File tree window
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },

    -- project + session management
    "olimorris/persisted.nvim",

    -- ====== Movement and editing ======
    -- Multicursor
    "mg979/vim-visual-multi",

    -- Automatically close pairs
    "altermo/ultimate-autopair.nvim",
    "alvan/vim-closetag",
    { "RRethy/nvim-treesitter-endwise", dependencies = { "nvim-treesitter/nvim-treesitter" } },

    -- Jump to pattern
    { "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
    "ggandor/flit.nvim",

    -- Text objects
    { "chrisgrieser/nvim-various-textobjs", opts = { useDefaultKeymaps = true } },

    -- ====== Integration ======
    -- Github Copilot
    "github/copilot.vim",

    -- Connect to Discord's RPC
    "andweeb/presence.nvim",

    -- Respect .editorconfig file
    "gpanders/editorconfig.nvim",

    -- Git
    "lewis6991/gitsigns.nvim",
    "sindrets/diffview.nvim",
    {
        "APZelos/blamer.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "akinsho/bufferline.nvim" },
    },

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
    { "AlphaTechnolog/pywal.nvim", as = "pywal" },
})
