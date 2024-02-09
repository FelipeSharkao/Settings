local function create_terminal(cmd)
    vim.cmd("tabnew")
    vim.cmd(cmd and "terminal " .. cmd or "terminal")

    -- disable number column
    vim.wo.number = false
    vim.wo.relativenumber = false

    vim.cmd("startinsert")
end

vim.api.nvim_create_user_command("Terminal", function(opts)
    create_terminal(opts.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("Git", function()
    create_terminal("lazygit")
end, {})
