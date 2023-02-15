require("scrollbar").setup({
    handle = {
        hide_if_all_visible = false,
        highlight = "Folded",
    },
    marks = {
        GitAdd = {
            text = "▎",
        },
        GitChange = {
            text = "▎",
        },
        GitDelete = {
            text = "▎",
        },
    },
    excluded_buftypes = {
        "terminal",
        "nofile",
    },
    excluded_filetypes = {
        "NvimTree",
    },
    handlers = {
        cursor = false,
        diagnostics = true,
        gitsigns = true,
    },
})
require("scrollbar.handlers.gitsigns").setup()
