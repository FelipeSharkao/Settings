local bufferline = require("bufferline")
local fp = require("fptools")
local ui = require("ui")

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

local buf_is_valid = function(buf)
    local loaded = vim.api.nvim_buf_is_loaded(buf)
    local listed = vim.api.nvim_buf_get_option(buf, "buflisted")
    local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
    return loaded and listed and buftype == ""
end

local list_valid_bufs = function()
    return fp.filter(vim.api.nvim_list_bufs(), buf_is_valid)
end

local next_buf = function(win, count)
    local buf = vim.api.nvim_win_get_buf(win)
    local bufs = list_valid_bufs()
    local idx = fp.index_of(bufs, buf) + count
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

local first_buf = function(win)
    local bufs = list_valid_bufs()
    vim.api.nvim_win_set_buf(win, bufs[1])
end

local last_buf = function(win)
    local bufs = list_valid_bufs()
    vim.api.nvim_win_set_buf(win, bufs[#bufs])
end

local delete_buf = function(buf)
    local modified = vim.api.nvim_buf_get_option(buf, "modified")
    local file = vim.api
        .nvim_buf_get_name(buf)
        :gsub("^" .. vim.fn.getcwd() .. "/", "")
        :gsub("^" .. vim.env.HOME, "~")

    local delete = function()
        local wins = vim.api.nvim_list_wins()
        for _, win in ipairs(wins) do
            if vim.api.nvim_win_get_buf(win) == buf then
                next_buf(win, 1)
            end
        end

        vim.api.nvim_buf_delete(buf, { force = true })
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
end

local delete_curr_buf = function()
    local current = vim.api.nvim_get_current_buf()
    delete_buf(current)
end

local delete_right_buf = function()
    local bufs = list_valid_bufs()
    local idx = fp.index_of(bufs, vim.api.nvim_get_current_buf())
    for i, _ in ipairs(bufs) do
        if i > idx then
            delete_buf(bufs[i])
        end
    end
end

local delete_left_buf = function()
    local bufs = list_valid_bufs()
    local idx = fp.index_of(bufs, vim.api.nvim_get_current_buf())
    for i, _ in ipairs(bufs) do
        if i == idx then
            break
        end
        delete_buf(bufs[i])
    end
end

local delete_surround_buf = function()
    delete_right_buf()
    delete_left_buf()
end

vim.api.nvim_create_user_command("BufClose", delete_curr_buf, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseAllRight", delete_right_buf, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseAllLeft", delete_left_buf, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseSurround", delete_surround_buf, { nargs = 0 })

keymap("n", "fj", fp.apply(next_buf, 0, -1), opts)
keymap("n", "fk", fp.apply(next_buf, 0, 1), opts)
keymap("n", "fh", fp.apply(first_buf, 0), opts)
keymap("n", "fl", fp.apply(last_buf, 0), opts)
keymap("n", "fx", delete_curr_buf, opts)
keymap("n", "fX", delete_surround_buf, opts)

bufferline.setup({
    options = {
        close_command = delete_buf,
        right_mouse_command = delete_buf,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, _, _)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
        end,
        separator_style = "slant",
        show_duplicated_prefix = true,
        max_name_length = 99,
        max_prefix_length = 99,
    },
    highlights = function()
        local bg = "#292D38"
        return {
            fill = { bg = bg },
            separator = { fg = bg },
            separator_visible = { fg = bg },
            separator_selected = { fg = bg },
        }
    end,
})
