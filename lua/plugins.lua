local fn = vim.fn
local installPath = DATA_PATH .. "/site/pack/packer/start/packer.nvim"

-- install packer if it's not installed already
local packerBootstrap = nil
if fn.empty(fn.glob(installPath)) > 0 then
	packerBootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", installPath })
	vim.cmd([[packadd packer.nvim]])
end

local packer = require("packer").startup(function(use)
	-- Packer should manage itself
	use("wbthomason/packer.nvim")

	-- surround vim
	use("tpope/vim-surround")

	-- status line
	use("glepnir/galaxyline.nvim")

	-- show recent files on empty nvim command
	use("mhinz/vim-startify")

	-- -- Prettier
	-- use("sbdchd/neoformat")

	-- floating terminal
	use("voldikss/vim-floaterm")

	-- LSP and linters
	use("folke/lsp-colors.nvim")
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")

	-- Debugging
	use("mfussenegger/nvim-dap")
	use("mxsdev/nvim-dap-vscode-js")

	-- Linters and formatters
	use("jose-elias-alvarez/null-ls.nvim")

	-- telescope - searching / navigation
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
			{ "nvim-telescope/telescope-project.nvim" },
			{ "nvim-telescope/telescope-dap.nvim" },
		},
	})

	-- better highlighting
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("evanleck/vim-svelte")

	-- File tree window
	use({
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- prettier tabs
	use("romgrk/barbar.nvim")

	-- -- Extensible LSP
	-- use({ "neoclide/coc.nvim", branch = "release" })

	-- Show commit messages
	use("APZelos/blamer.nvim")

	-- show indentation levels
	use("lukas-reineke/indent-blankline.nvim")

	-- improve folding
	use("anuvyklack/pretty-fold.nvim")

	-- Github Copilot
	use("github/copilot.vim")

	-- Multicursor
	use("mg979/vim-visual-multi")

	-- Automaticly close () [] {} '' ""
	use("jiangmiao/auto-pairs")

	-- colorscheme
	use({
		"rose-pine/neovim",
		as = "rose-pine",
		tag = "v1.*",
	})

	-- this will automatically install listed dependencies
	-- only the first time NeoVim is opened, because that's when Packer gets installed
	if packerBootstrap then
		require("packer").sync()
	end
end)

-- plugin specific configs go here
require("plugin-config/telescope")
require("plugin-config/floaterm")
require("plugin-config/lsp")
require("plugin-config/null-ls")
require("plugin-config/dap")
require("plugin-config/nvim-treesitter")
require("plugin-config/barbar")
require("plugin-config/blamer")
require("plugin-config/pretty-fold")
require("plugin-config/copilot")
require("plugin-config/galaxyline")
require("plugin-config/indent-guide-lines")
require("plugin-config/nvim-tree")
require("plugin-config/theme")

return packer
