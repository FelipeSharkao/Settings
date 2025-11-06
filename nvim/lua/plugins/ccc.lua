local ft = {
    "css",
    "scss",
    "sass",
    "stylus",
    "htmtl",
    "javascriptreact",
    "typescriptreact",
    "svelte",
    "astro",
}

---@type LazySpec[]
return {
    {
        "uga-rosa/ccc.nvim",
        event = { "BufEnter", "BufWinEnter" },
        ft = ft,
        opts = function()
            local ccc = require("ccc")
            return {
                highlighter = {
                    auto_enable = true,
                    filetypes = ft,
                },
                inputs = {
                    ccc.input.rgb,
                    ccc.input.hsl,
                },
                pickers = {
                    ccc.picker.hex,
                    ccc.picker.css_rgb,
                    ccc.picker.css_hsl,
                },
                recognize = { input = true, output = true },
            }
        end,
        cmd = {
            "CccPick",
            "CccConvert",
            "CccHighlighterEnable",
            "CccHighlighterDisable",
            "CccHighlighterToggle",
        },
    },
}
