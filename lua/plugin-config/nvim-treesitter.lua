require'nvim-treesitter.configs'.setup {
  -- will install treesitter for all available languages
  ensure_installed = 'all',
  ignore_install = {"haskell"}, -- broken
  highlight = {
    enable = true
  }
}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
