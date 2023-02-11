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

	-- surround vim
	"tpope/vim-surround",

	-- status line
	"glepnir/galaxyline.nvim",

	-- show recent files on empty nvim command
	"mhinz/vim-startify",

	-- floating terminal
	"voldikss/vim-floaterm",

	-- LSP and linters
	"folke/lsp-colors.nvim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"jay-babu/mason-null-ls.nvim",
	"jose-elias-alvarez/null-ls.nvim",

	-- Debugging
	"mfussenegger/nvim-dap",
	"mxsdev/nvim-dap-vscode-js",

	-- Suggestions and completion
	"hrsh7th/vim-vsnip",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/cmp-vsnip",

	-- Better suggestions in config files
	"folke/neodev.nvim",

	-- Respect .editorconfig file
	"gpanders/editorconfig.nvim",

	-- telescope - searching / navigation
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-dap.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
	},

	-- better highlighting
	{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
	"evanleck/vim-svelte",
	"preservim/vim-markdown",

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

	-- File tree window
	{ "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- prettier tabs
	{ "akinsho/bufferline.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- Show commit messages
	{
		"APZelos/blamer.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "akinsho/bufferline.nvim" },
	},

	-- show indentation levels
	"lukas-reineke/indent-blankline.nvim",

	-- improve folding
	"anuvyklack/pretty-fold.nvim",

	-- Github Copilot
	"github/copilot.vim",

	-- Multicursor
	"mg979/vim-visual-multi",

	-- Automaticly close () [] {} '' ""
	"jiangmiao/auto-pairs",

	-- Jump to pattern
	{ "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
	"ggandor/flit.nvim",

	-- colorscheme
	{ "rose-pine/neovim", name = "rose-pine" },
	"nyoom-engineering/oxocarbon.nvim",

	-- Connect to Discord's RPC
	"andweeb/presence.nvim",
})

-- plugin specific configs go here
require("plugin-config/telescope")
require("plugin-config/floaterm")
require("plugin-config/lsp")
require("plugin-config/dap")
require("plugin-config/nvim-cmp")
require("plugin-config/nvim-treesitter")
require("plugin-config/bufferline")
require("plugin-config/blamer")
require("plugin-config/pretty-fold")
require("plugin-config/copilot")
require("plugin-config/galaxyline")
require("plugin-config/indent-guide-lines")
require("plugin-config/nvim-tree")
require("plugin-config/autopairs")
require("plugin-config/leap")
require("plugin-config/theme")
require("plugin-config/discord")
