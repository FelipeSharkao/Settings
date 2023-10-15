local ui = require("utils.ui")

local M = {}

M.is_valid = function(buf)
    local is_listed = vim.api.nvim_buf_get_option(buf, "buflisted")
    local is_file = vim.api.nvim_buf_get_option(buf, "buftype") == ""

    return is_listed and is_file
end

M.list = function()
    return vim.tbl_filter(M.is_valid, vim.api.nvim_list_bufs())
end

M.next = function(win, count)
    local buf = vim.api.nvim_win_get_buf(win)
    local bufs = M.list()
    local idx = vim.tbl_index(buf, bufs) + count
    if idx > #bufs then
        idx = idx - #bufs
    elseif idx < 1 then
        idx = idx + #bufs
    end
    -- If we've looped around, there's nothing left to do.
    if bufs[idx] ~= buf then
        vim.api.nvim_win_set_buf(win, bufs[idx])
    end
end

M.first = function(win)
    local bufs = M.list()
    vim.api.nvim_win_set_buf(win, bufs[1])
end

M.last = function(win)
    local bufs = M.list()
    vim.api.nvim_win_set_buf(win, bufs[#bufs])
end

M.delete = function(buf)
    local modified = vim.api.nvim_buf_get_option(buf, "modified")
    local file = vim.api
        .nvim_buf_get_name(buf)
        :gsub("^" .. vim.fn.getcwd() .. "/", "")
        :gsub("^" .. vim.env.HOME, "~")

    local delete = function()
        -- Use bbye to delete the buffer so the window doesn't close.
        vim.cmd("Bdelete! " .. buf)
    end

    local save_and_delete = function()
        if file == "" then
            vim.ui.input({ prompt = "Save as: " }, function(name)
                vim.cmd("silent! saveas " .. name)
                delete()
            end)
            return
        end

        vim.cmd("silent! write")
        delete()
    end

    if not modified then
        delete()
        return
    end

    if M.is_valid(buf) then
        ui.dialog(
            { "&Save", "&Discard", "&Cancel" },
            { prompt = "Save changes to " .. (file or "buffer") .. "?" },
            function(choice)
                if choice == 1 then
                    save_and_delete()
                elseif choice == 2 then
                    delete()
                end
            end
        )
    else
        ui.dialog(
            { "&Close", "&Cancel" },
            { prompt = "Close " .. (file or "buffer") .. "?" },
            function(choice)
                if choice == 1 then
                    delete()
                end
            end
        )
    end
end

M.delete_current = function()
    local current = vim.api.nvim_get_current_buf()
    M.delete(current)
end

M.delete_right = function()
    local bufs = M.list()
    local idx = vim.tbl_index(vim.api.nvim_get_current_buf(), bufs)
    for i, _ in ipairs(bufs) do
        if i > idx then
            M.delete(bufs[i])
        end
    end
end

M.delete_left = function()
    local bufs = M.list()
    local idx = vim.tbl_index(vim.api.nvim_get_current_buf(), bufs)
    for i, _ in ipairs(bufs) do
        if i < idx then
            M.delete(bufs[i])
        end
    end
end

M.delete_surrounding = function()
    M.delete_right()
    M.delete_left()
end

return M
