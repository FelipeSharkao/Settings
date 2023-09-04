local T = require("utils.table")
local UI = require("utils.ui")

local M = {}

M.buf_is_valid = function(buf)
    local is_listed = vim.api.nvim_buf_get_option(buf, "buflisted")
    local is_file = vim.api.nvim_buf_get_option(buf, "buftype") == ""

    return is_listed and is_file
end

M.list_bufs = function()
    return T.filter(vim.api.nvim_list_bufs(), M.buf_is_valid)
end

M.next_buf = function(win, count)
    local buf = vim.api.nvim_win_get_buf(win)
    local bufs = M.list_bufs()
    local idx = T.index_of(bufs, buf) + count
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

M.first_buf = function(win)
    local bufs = M.list_bufs()
    vim.api.nvim_win_set_buf(win, bufs[1])
end

M.last_buf = function(win)
    local bufs = M.list_bufs()
    vim.api.nvim_win_set_buf(win, bufs[#bufs])
end

M.delete_buf = function(buf)
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

    if M.buf_is_valid(buf) then
        UI.dialog(
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
        UI.dialog(
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

M.delete_curr_buf = function()
    local current = vim.api.nvim_get_current_buf()
    M.delete_buf(current)
end

M.delete_right_buf = function()
    local bufs = M.list_bufs()
    local idx = T.index_of(bufs, vim.api.nvim_get_current_buf())
    for i, _ in ipairs(bufs) do
        if i > idx then
            M.delete_buf(bufs[i])
        end
    end
end

M.delete_left_buf = function()
    local bufs = M.list_bufs()
    local idx = T.index_of(bufs, vim.api.nvim_get_current_buf())
    for i, _ in ipairs(bufs) do
        if i < idx then
            M.delete_buf(bufs[i])
        end
    end
end

M.delete_surround_buf = function()
    M.delete_right_buf()
    M.delete_left_buf()
end

return M
