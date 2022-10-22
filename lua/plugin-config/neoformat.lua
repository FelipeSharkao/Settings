vim.g.neoformat_try_node_exe = 1
vim.g.neoformat_enabled_javascript = { "prettier" }
vim.g.neoformat_enabled_typescript = { "prettier" }
vim.g.neoformat_enabled_graphql = { "prettier" }
vim.g.neoformat_enabled_prisma = { "prettier" }
vim.g.neoformat_enabled_lua = { "stylua" }
vim.g.neoformat_enabled_rust = { "rustfmt" }

vim.api.nvim_command([[autocmd BufWritePre * silent Neoformat]])
