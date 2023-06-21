require("nvim-tree").setup({
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
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
    renderer = {
        root_folder_label = false,
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
