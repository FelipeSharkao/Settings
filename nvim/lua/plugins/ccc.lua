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
            local utils = require("ccc.utils")
            local convert = require("ccc.utils.convert")
            local parse = require("ccc.utils.parse")
            local pattern = require("ccc.utils.pattern")

            -- HSV picker
            ---@class ccc.ColorPicker.CssHsv: ccc.ColorPicker
            ---@field patten string[]
            local CssHsvPicker = {}

            function CssHsvPicker:init()
                if self.pattern then return end
                self.pattern = {
                    pattern.create(
                        "hsva?( [<hue>|none]  [<percentage>|none]  [<percentage>|none] %[/ [<alpha-value>|none]]? )"
                    ),
                    pattern.create(
                        "hsva?( [<hue>] , [<percentage>] , [<percentage>] %[, [<alpha-value>]]? )"
                    ),
                }
            end

            ---@param s string
            ---@param init? integer
            ---@return integer? start_col
            ---@return integer? end_col
            ---@return RGB? rgb
            ---@return Alpha? alpha
            function CssHsvPicker:parse_color(s, init)
                self:init()
                init = init or 1
                -- The shortest patten is 12 characters like `hsv(0 0% 0%)`
                while init <= #s - 11 do
                    local start_col, end_col, cap1, cap2, cap3, cap4
                    for _, pat in ipairs(self.pattern) do
                        start_col, end_col, cap1, cap2, cap3, cap4 =
                            pattern.find(s, pat, init)
                        if start_col then break end
                    end
                    if not (start_col and end_col and cap1 and cap2 and cap3) then
                        return
                    end
                    local H = parse.hue(cap1)
                    local S = parse.percent(cap2)
                    local V = parse.percent(cap3)
                    if H and utils.valid_range({ S, V }, 0, 1) then
                        local RGB = convert.hsv2rgb({ H, S, V })
                        local A = parse.alpha(cap4)
                        return start_col, end_col, RGB, A
                    end
                    init = end_col + 1
                end
            end

            return {
                highlighter = {
                    auto_enable = true,
                    filetypes = ft,
                },
                inputs = {
                    ccc.input.rgb,
                    ccc.input.hsv,
                },
                pickers = {
                    ccc.picker.hex,
                    ccc.picker.css_rgb,
                    CssHsvPicker,
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
