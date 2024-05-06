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

    -- Better UI for select actions
    { "stevearc/dressing.nvim", dependencies = { "MunifTanjim/nui.nvim" } },

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
    "uarun/vim-protobuf",

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

    -- close unused buffers when the buffer list gets too crowded
    {
        "axkirillov/hbac.nvim",
        lazy = true,
        event = "BufEnter",
        opts = {
            autoclose = true,
            threshold = 10,
            close_buffers_with_windows = false,
        },
    },

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
    -- Multicursor
    "mg979/vim-visual-multi",

    -- Automatically close pairs
    "alvan/vim-closetag",
    { "RRethy/nvim-treesitter-endwise", dependencies = { "nvim-treesitter/nvim-treesitter" } },

    -- Text objects
    {
        "chrisgrieser/nvim-various-textobjs",
        opts = { useDefaultKeymaps = true, disableKeymaps = { "gc" } },
    },

    -- ====== Integration ======
    -- Github Copilot
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept_line = "<Right>",
                },
            },
        },
    },

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
    "raddari/last-color.nvim",

    -- ====== colorscheme ======
    { "rose-pine/neovim", name = "rose-pine" },
    { "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon" },
    { "folke/tokyonight.nvim", name = "tokyonight" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "AlphaTechnolog/pywal.nvim", as = "pywal" },
})
