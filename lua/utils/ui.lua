local popup = require("plenary.popup")

local M = {}

--- @class DialogChoice
--- @field label string The label to show.
--- @field callback fun()|nil The callback to call when this choice is selected.

--- @class DialogOptions
--- @field title string The title of the popup window.
--- @field choices DialogChoice[] The choices to show.

--- Shows a dialog popup.
--- @param options DialogOptions The options to use.
M.dialog = function(options)
    local content_width = options.title:len() + 2
    for _, choice in ipairs(options.choices) do
        content_width = math.max(content_width, #choice.label + 5)
    end

    local width = content_width + 2
    local height = #options.choices

    local choice_number = 0
    local lines = vim.tbl_map(function(choice)
        choice_number = choice_number + 1
        return string.format("[%i] %s", choice_number, choice.label)
    end, options.choices)

    local win = nil
    win = popup.create(lines, {
        title = options.title,
        line = math.floor((vim.o.lines - height) / 2 - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        callback = function(_, label)
            local i = tonumber(label:match("^%[(%d+)%]"))
            local choice = options.choices[i]

            if choice and choice.callback then
                choice.callback()
            end

            vim.api.nvim_win_close(win, true)
        end,
    })

    local function close()
        vim.api.nvim_win_close(win, true)
    end

    local bufnr = vim.api.nvim_win_get_buf(win)
    local keymap_opts = { buffer = bufnr, noremap = true, silent = true }

    for i, choice in ipairs(options.choices) do
        vim.keymap.set("n", tostring(i), function()
            if choice.callback then
                choice.callback()
            end

            close()
        end, keymap_opts)
    end

    vim.keymap.set("n", "q", close, keymap_opts)
    vim.keymap.set("n", "<Esc>", close, keymap_opts)
    vim.keymap.set("n", "<C-c>", close, keymap_opts)
    vim.keymap.set("n", "<C-q>", close, keymap_opts)
end

return M
