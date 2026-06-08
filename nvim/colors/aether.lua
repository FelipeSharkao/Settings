local colors = dofile(vim.env.HOME .. "/.config/aether/theme/nvim-colors.lua")

vim.o.background = colors.theme_type

local utils = require("plugin-utils.colors")

local function blend(from, to, factor)
    return utils.format(utils.blend(from, to, factor), "hex")
end

local function bolden(color, factor)
    local to = colors.theme_type == "light" and "#000000" or "#ffffff"
    return utils.format(utils.blend(color, to, factor), "hex")
end

require("mini.base16").setup({
    palette = {
        base00 = colors.background,
        base02 = blend(colors.background, colors.muted, 0.2),
        base01 = blend(colors.background, colors.muted, 0.4),
        base03 = colors.muted,
        base04 = blend(colors.muted, colors.foreground, 0.6),
        base05 = colors.foreground,
        base06 = bolden(colors.foreground, 0.2),
        base07 = bolden(colors.foreground, 0.4),
        base08 = colors.red,
        base09 = colors.orange,
        base0A = colors.yellow,
        base0B = colors.green,
        base0C = colors.cyan,
        base0D = colors.blue,
        base0E = colors.purple,
        base0F = colors.brown,
    },
})

require("aether").load({ colors = colors })

-- adjust some colors

for _, hl in ipairs({
    "WinBar",
    "WinBarNC",
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
    "DiagnosticSignOk",
}) do
    vim.api.nvim_set_hl(0, hl, { bg = "NONE", update = true })
end

utils.hl_soften_bg("Visual", 0.8)
utils.hl_bolden_bg("ColorColumn", 0.2)

for _, hl in ipairs({
    "NormalFloat",
    "FloatBorder",
    "FloatTitle",
    "FloatFooter",
    "TelescopeNormal",
    "TelescopeBorder",
}) do
    utils.hl_soften_bg(hl, 0.4)
end

for _, hl in ipairs({ "MiniCursorword", "MiniCursorwordCurrent" }) do
    vim.api.nvim_set_hl(0, hl, { underline = true })
end
