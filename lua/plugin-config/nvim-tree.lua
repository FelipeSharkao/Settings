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
        highlight_git = true,
        highlight_opened_files = "all",
    },
    on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
            return {
                desc = "nvim-tree: " .. desc,
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true,
            }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
        vim.keymap.set("n", "D", api.fs.remove, opts("Delete"))
    end,
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
