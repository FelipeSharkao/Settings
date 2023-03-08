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

local function open_nvim_tree(data)
    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1

    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    if not real_file and not no_name then
        return
    end

    -- open the tree, find the file but don't focus it
    api.tree.toggle({ focus = false, find_file = true })
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local opts = { silent = true, noremap = true }
vim.keymap.set("n", ";n", function()
    api.tree.open({ find_file = true })
end, opts)
