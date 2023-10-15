local bufferline = require("bufferline")
local utils = require("utils")

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

vim.api.nvim_create_user_command("BufClose", utils.buf.delete_current, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseRight", utils.buf.delete_right, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseLeft", utils.buf.delete_left, { nargs = 0 })
vim.api.nvim_create_user_command("BufCloseSurround", utils.buf.delete_surrounding, { nargs = 0 })

keymap("n", "fj", utils.func.apply(utils.buf.next, 0, -1), opts)
keymap("n", "fk", utils.func.apply(utils.buf.next, 0, 1), opts)
keymap("n", "fh", utils.func.apply(utils.buf.first, 0), opts)
keymap("n", "fl", utils.func.apply(utils.buf.last, 0), opts)
keymap("n", "fx", utils.buf.delete_current, opts)
keymap("n", "fX", utils.buf.delete_surrounding, opts)

bufferline.setup({
    options = {
        close_command = utils.buf.delete,
        right_mouse_command = utils.buf.delete,
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
