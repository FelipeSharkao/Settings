-- mini.nvim adds a lot of modolar features, improving the general experience

-- Extends a/i textobjects
require("mini.ai").setup()

-- Highlight the word under the cursor
require("mini.cursorword").setup()

-- Opinated statusline
require("mini.statusline").setup()

-- Surround actions
require("mini.surround").setup({
    mappings = {
        add = "ys",
        delete = "ds",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "cs",
        update_n_lines = "gss",
    },
})
