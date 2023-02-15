-- mini.nvim adds a lot of modolar features, improving the general experience

-- Extends a/i textobjects
require("mini.ai").setup()

-- Add/remove comments
require("mini.comment").setup({
    mappings = {
        comment = ";",
        comment_line = ";;",
        textobject = ";",
    },
})

-- Highlight the word under the cursor
require("mini.cursorword").setup()

-- Opinated statusline
require("mini.statusline").setup()

-- Surround actions
require("mini.surround").setup({
    mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
    },
})
