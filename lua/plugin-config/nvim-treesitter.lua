require'nvim-treesitter.configs'.setup {
  -- will install treesitter for all available languages
  ensure_installed = 'all',
  ignore_install = {"haskell"}, -- broken
  highlight = {
    enable = true
  }
}

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldlevel = 99
