local opts = { noremap = true, silent = true }
local xopts = { noremap = true, silent = true, expr = true }

vim.g.coc_global_extensions = {
  'coc-json',
  'coc-git',
  'coc-tsserver',
  'coc-emmet',
  'coc-highlight',
  'coc-rust-analyzer',
  'coc-svelte',
  'coc-sh',
  'coc-sumneko-lua',
  'coc-eslint',
}

vim.g.coc_default_semantic_highlight_groups = 1

vim.api.nvim_set_keymap('n', 'gd', '<Cmd>call CocAction("jumpDefinition")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gt', '<Cmd>call CocAction("jumpTypeDefinition")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gD', '<Cmd>call CocAction("jumpDeclaration")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>call CocAction("jumpImplementation")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<Cmd>call CocAction("jumpReferences")<CR>', opts)

vim.api.nvim_set_keymap('n', 'gr', '<Cmd>call CocActionAsync("rename")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gR', '<Cmd>call CocAction("refactor")<CR>', opts)
vim.api.nvim_set_keymap('n', 'ga', '<Cmd>call CocAction("codeAction", "cursor")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gh', '<Cmd>call CocAction("doHover")<CR>', opts)
vim.api.nvim_set_keymap('n', 'gH', '<Cmd>call CocAction("definitionHover")<CR>', opts)

-- if autocomplete popup menu opens pressing tab will complete the first match
vim.api.nvim_set_keymap('i', '<Tab>', 'coc#pum#visible() ? coc#_select_confirm() : "<Tab>"', xopts)
vim.api.nvim_set_keymap('i', '<C-Space>', 'coc#refresh()', xopts)
vim.api.nvim_set_keymap('i', '<C-@>', 'coc#refresh()', xopts)
