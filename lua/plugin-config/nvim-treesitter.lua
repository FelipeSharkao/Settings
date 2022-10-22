require'nvim-treesitter.configs'.setup {
  -- will install treesitter for all available languages
  ensure_installed = 'all',
  ignore_install = {"haskell"}, -- broken
  highlight = {
    enable = true
  }
}

-- Treesitter folding is broken: https://github.com/nvim-treesitter/nvim-treesitter/issues/1424
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldmethod = 'indent'
vim.wo.foldlevel = 99
