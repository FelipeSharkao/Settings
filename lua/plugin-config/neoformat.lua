vim.g.neoformat_try_node_exe = 1
vim.g.neoformat_enabled_javascript = {'prettier'}
vim.g.neoformat_enabled_typescript = {'prettier'}

vim.api.nvim_command([[
autocmd BufWritePre * try | undojoin | Neoformat | catch /E790/ | Neoformat | endtry
]])
