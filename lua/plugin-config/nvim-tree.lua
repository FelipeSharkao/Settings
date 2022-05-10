local opts = {silent = true, noremap = true}
vim.api.nvim_set_keymap('n', 'N', '<Cmd>NvimTreeToggle<CR>', opts)

require('nvim-tree').setup {
  disable_netrw = true,
  hijack_cursor = true,
  open_on_setup = true,
  actions = {
    open_file = {
      quit_on_open = true
    }
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable = true
  },
  view = {
    hide_root_folder = true,
  }
}
