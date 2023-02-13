require("scrollbar").setup({
    handle = {
        hide_if_all_visible = false,
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
    handlers = {
        cursor = false,
        diagnostics = true,
        gitsigns = true,
    },
})
require("scrollbar.handlers.gitsigns").setup()
