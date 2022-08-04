local fn = vim.fn
local installPath = DATA_PATH..'/site/pack/packer/start/packer.nvim'

-- install packer if it's not installed already
local packerBootstrap = nil
if fn.empty(fn.glob(installPath)) > 0 then
  packerBootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', installPath})
  vim.cmd [[packadd packer.nvim]]
end

local packer = require('packer').startup(function(use)
  -- Packer should manage itself
  use 'wbthomason/packer.nvim'
  
  -- Git integration
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'
  use {'APZelos/blamer.nvim', config = function()
    vim.g.blamer_enabled = true
    vim.g.blamer_delay = 600
  end}

  -- surround vim
  use 'tpope/vim-surround'

  -- nerd commenter
  use 'scrooloose/nerdcommenter'

  -- status line
  use 'glepnir/galaxyline.nvim'

  -- show recent files on empty nvim command
  use 'mhinz/vim-startify'

  -- lsp config
  use {
    'neovim/nvim-lspconfig',
    'williamboman/nvim-lsp-installer',
  }

  -- for LSP autocompletion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'

  -- Prettier
  use 'sbdchd/neoformat'

  -- TODO: prettify telescope vim, make it use regex & shorten the window
  -- telescope - searching / navigation
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    }
  }

  -- better highlighting
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'evanleck/vim-svelte'

  -- File tree window
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
  }

  -- prettier tabs
  use 'romgrk/barbar.nvim'

  -- support the missing lsp diagnostic colors
  use 'folke/lsp-colors.nvim'

  -- Extensible LSP
  use {'neoclide/coc.nvim', branch = 'release'}

  -- show indentation levels
  use 'lukas-reineke/indent-blankline.nvim'

  -- improve folding
  use 'anuvyklack/pretty-fold.nvim'

  -- Github Copilot
  -- Sadly I won't pay it for now
  -- use 'github/copilot.vim'
  
  -- Multicursor
  use 'mg979/vim-visual-multi'

  -- Automaticly close () [] {} '' ""
  use 'jiangmiao/auto-pairs'
  
  -- colorscheme
  use {
    'rose-pine/neovim',
    as = 'rose-pine',
    tag = 'v1.*',
  }

  -- this will automatically install listed dependencies
  -- only the first time NeoVim is opened, because that's when Packer gets installed
  if packerBootstrap then
    require('packer').sync()
  end
end)

-- plugin specific configs go here
require('plugin-config/nvim-cmp')
require('plugin-config/telescope')
require('plugin-config/nvim-treesitter')
require('plugin-config/barbar')
require('plugin-config/lsp-colors')
require('plugin-config/coc')
require('plugin-config/pretty-fold')
require('plugin-config/neoformat')
require('plugin-config/galaxyline')
require('plugin-config/indent-guide-lines')
require('plugin-config/nvim-tree')
require('plugin-config/theme')

return packer
