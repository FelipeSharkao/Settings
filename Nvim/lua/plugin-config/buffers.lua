local function buf_delete(bufnr, opts)
    local cmd = nil

    if opts.keep_windows then
        cmd = opts.wipeout and "Bwipeout" or "Bdelete"
    else
        cmd = opts.wipeout and "bwipeout" or "bdelete"
    end

    vim.cmd({ cmd = cmd, args = { bufnr }, bang = opts.force })
end

require("hbac").setup({
    autoclose = true,
    threshold = 10,
    close_command = function(bufnr)
        buf_delete(bufnr, {})
    end,
    close_buffers_with_windows = false,
})

vim.api.nvim_create_user_command("BufDel", function(opts)
    local bufnr = opts.args ~= "" and opts.args or vim.fn.bufnr()
    buf_delete(bufnr, { force = opts.bang or false, keep_windows = true })
end, { nargs = "?", bang = true, complete = vim.api.nvim_list_bufs })

vim.api.nvim_create_user_command("BufDelOthers", function(opts)
    local bufnr = opts.args ~= "" and opts.args or vim.fn.bufnr()

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= bufnr then
            buf_delete(buf, { force = opts.bang or false })
        end
    end
end, { nargs = "?", bang = true, complete = vim.api.nvim_list_bufs })

-- wipe out the buffer if the source file is deleted
vim.api.nvim_create_autocmd("FileChangedShell", {
    callback = function(ev)
        if
            vim.v.fcs_reason == "deleted" and not vim.api.nvim_buf_get_option(ev.buf, "modified")
        then
            buf_delete(ev.buf, { wipeout = true, keep_windows = true })
        end
    end,
})
