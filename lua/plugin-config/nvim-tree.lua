require("nvim-tree").setup({
    disable_netrw = true,
    hijack_cursor = true,
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
    },
    view = {
        hide_root_folder = true,
    },
    renderer = {
        highlight_git = true,
        highlight_opened_files = "all",
    },
})

require("nvim-web-devicons").setup({
    color_icons = true,
    default = true,
})

local api = require("nvim-tree.api")

local opts = { silent = true, noremap = true }
vim.keymap.set("n", ";n", function()
    api.tree.toggle({ find_file = true })
end, opts)
