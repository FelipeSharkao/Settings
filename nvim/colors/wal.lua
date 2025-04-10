vim.o.termguicolors = true

vim.cmd("source $HOME/.cache/wal/colors-wal.vim")

vim.o.background = (vim.g.colors_light == 1 and "light") or "dark"

-- using colors.foreground leads to somewhat boring results
local fg_colors = {
    vim.g.color9,
    vim.g.color10,
    vim.g.color11,
    vim.g.color12,
    vim.g.color13,
    vim.g.color14,
    vim.g.foreground,
}

for _, fg in ipairs(fg_colors) do
    local success = pcall(require("mini.hues").setup, {
        background = vim.g.background,
        foreground = fg,
        saturation = "medium",
        accent = "fg",
    })

    if success then
        break
    end
end

vim.cmd("hi WinBar guibg=NONE")
