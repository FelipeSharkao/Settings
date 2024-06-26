require("pywal").setup()

vim.o.termguicolors = true
vim.o.background = "dark"

local pywal_core = require("pywal.core")
local colors = pywal_core.get_colors()

-- mini.hues will fail if background and foreground are too similar. As the colors are a little
-- unpredictable, will just try a bunch
-- using colors.foreground leads to somewhat boring results
local fg_colors = {
    colors.color1,
    colors.color2,
    colors.color3,
    colors.color4,
    colors.color5,
    colors.color6,
    colors.color7,
    colors.foreground,
}

for _, fg in ipairs(fg_colors) do
    local success = pcall(require("mini.hues").setup, {
        background = colors.background,
        foreground = fg,
        saturation = "medium",
        accent = "fg",
    })

    if success then
        break
    end
end

vim.cmd("hi WinBar guibg=NONE")
vim.cmd("hi link LspInlayHint Commnet")
