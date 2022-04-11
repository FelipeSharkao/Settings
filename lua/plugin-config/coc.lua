local opts = { noremap = true, silent = true }

vim.g.coc_global_extensions = {
  'coc-json',
  'coc-git',
  'coc-tsserver',
  'coc-emmet',
  'coc-highlight',
  'coc-rust-analyzer',
  'coc-svelte',
  'coc-sh',
  'coc-lua',
}

vim.api.nvim_set_keymap('n', 'gd', '<Cmd>call CocAction("jumpDefinition")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gt', '<Cmd>call CocAction("jumpTypeDefinition")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gD', '<Cmd>call CocAction("jumpDeclaration")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>call CocAction("jumpImplementation")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>call CocAction("jumpReferences")<CR>', opts)

vim.api.nvim_set_keymap('n', 'gr', '<Cmd>call CocActionAsync("rename")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gR', '<Cmd>call CocAction("refactor")<CR>', opts)
vim.api.nvim_set_keymap('n', 'ga', '<Cmd>call CocAction("codeAction")<CR>', opts)
vim.api.nvim_set_keymap('n', 'h', '<Cmd>call CocAction("doHover")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gh', '<Cmd>call CocAction("definitionHover")<CR>', opts)
