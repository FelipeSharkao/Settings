local bufferline = require("bufferline")
local utils = require("utils")

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

vim.api.nvim_create_user_command("BufClose", utils.delete_curr_buf, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseAllRight", utils.delete_right_buf, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseAllLeft", utils.delete_left_buf, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseSurround", utils.delete_surround_buf, { nargs = 0 })

keymap("n", "fj", utils.apply(utils.next_buf, 0, -1), opts)
keymap("n", "fk", utils.apply(utils.next_buf, 0, 1), opts)
keymap("n", "fh", utils.apply(utils.first_buf, 0), opts)
keymap("n", "fl", utils.apply(utils.last_buf, 0), opts)
keymap("n", "fx", utils.delete_curr_buf, opts)
keymap("n", "fX", utils.delete_surround_buf, opts)

bufferline.setup({
    options = {
        close_command = utils.delete_buf,
        right_mouse_command = utils.delete_buf,
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
