vim.g.floaterm_keymap_new = "<F7>"
vim.g.floaterm_keymap_prev = "<F8>"
vim.g.floaterm_keymap_next = "<F9>"

vim.api.nvim_create_user_command("Git", "FloatermNew --cwd=<buffer> --width=0.8 --height=0.8 lazygit", {})
