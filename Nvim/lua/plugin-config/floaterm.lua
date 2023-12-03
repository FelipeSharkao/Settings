vim.g.floaterm_width = 0.9
vim.g.floaterm_height = 0.9
vim.g.floaterm_giteditor = false

vim.api.nvim_create_user_command("Run", "FloatermNew --autoclose=0 <args>", { nargs = "*" })
vim.api.nvim_create_user_command(
    "RunHere",
    "FloatermNew --autoclose=0 --cwd=<buffer> <args>",
    { nargs = "*" }
)
