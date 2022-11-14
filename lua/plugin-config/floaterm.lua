vim.api.nvim_create_user_command("Git", "FloatermNew --cwd=<buffer> --width=0.8 --height=0.8 lazygit", {})
vim.api.nvim_create_user_command("Run", "FloatermNew --autoclose=0 <args>", { nargs = "*" })
vim.api.nvim_create_user_command("RunHere", "FloatermNew --autoclose=0 --cwd=<buffer> <args>", { nargs = "*" })
