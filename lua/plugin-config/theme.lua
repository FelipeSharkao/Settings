require("rose-pine").setup({
    dark_variant = "main",
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = false,
    groups = {
        background = "base",
        panel = "surface",
        border = "highlight_med",
        comment = "muted",
        link = "iris",
        punctuation = "subtle",

        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",

        headings = {
            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },
    },
})

require("tokyonight").setup({
    style = "night",
    light_style = "day",
})

require("catppuccin").setup({
    flavour = "mocha",
    background = {
        light = "latte",
        dark = "mocha",
    },
    color_overrides = {
        all = {},
        latte = {},
        frappe = {},
        macchiato = {},
        mocha = {
            base = "#171721",
            mantle = "#12121a",
            crust = "#0a0a0f",
        },
    },
})

local theme = require("last-color").recall() or "rose-pine"

vim.cmd("colorscheme " .. theme)

vim.o.termguicolors = true
vim.o.background = "dark"
