local M = {}

--- Parse a color in any format to {R, G, B} with 0-1 range
---@param color string|number|number[] hex string "#123456", number 0x123456, or {R,G,B} 0-1
---@return number[] rgb
function M.parse(color)
    local hex = require("ccc.utils.hex")

    if type(color) == "table" then
        return color
    elseif type(color) == "number" then
        local r = bit.rshift(color, 16)
        local g = bit.band(bit.rshift(color, 8), 0xFF)
        local b = bit.band(color, 0xFF)
        return { r / 255, g / 255, b / 255 }
    elseif type(color) == "string" then
        if #color == 9 then color = color:sub(1, 7) end
        return hex.parse(color)
    end
    error("unknown color format: " .. type(color))
end

--- Format {R, G, B} 0-1 to requested output kind
---@param rgb number[] {R, G, B} in 0-1 range
---@param kind "hex"|"number" output format
---@overload fun(rgb: number[], kind: "hex"): string
---@overload fun(rgb: number[], kind: "number"): number
function M.format(rgb, kind)
    local convert = require("ccc.utils.convert")
    local hex = require("ccc.utils.hex")

    if kind == "hex" then
        return hex.stringify(rgb)
    elseif kind == "number" then
        local r, g, b = convert.rgb_format(rgb)
        return bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b)
    end
    error("unknown format kind: " .. kind)
end

--- Blend two colors perceptually using OKLab
---@param from_color string|number|number[] start color
---@param to_color string|number|number[] end color
---@param factor number 0 = from_color, 1 = to_color
---@return number[] rgb {R, G, B} in 0-1 range
function M.blend(from_color, to_color, factor)
    local convert = require("ccc.utils.convert")

    if factor <= 0 then return M.parse(from_color) end
    if factor >= 1 then return M.parse(to_color) end

    local from = M.parse(from_color)
    local to = M.parse(to_color)

    local from_oklab = convert.rgb2oklab(from)
    local to_oklab = convert.rgb2oklab(to)

    local result_oklab = {}
    for i = 1, 3 do
        result_oklab[i] = from_oklab[i] + (to_oklab[i] - from_oklab[i]) * factor
    end

    return convert.oklab2rgb(result_oklab)
end

--- Blend the highlight group's background with the Normal background
---@param name string highlight group name
---@param factor number 0 = highlight group, 1 = Normal
function M.hl_soften_bg(name, factor)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if hl.bg == nil or hl.bg == "NONE" then return end

    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    if normal_hl.bg == nil or normal_hl.bg == "NONE" then return end

    local bg_rgb = M.blend(hl.bg, normal_hl.bg, factor)
    local bg_hex = M.format(bg_rgb, "number")
    vim.api.nvim_set_hl(0, name, { bg = bg_hex, default = false, update = true })
end

--- Blend the highlight group's background with its foreground
---@param name string highlight group name
---@param factor number 0 = background, 1 = foreground
function M.hl_bolden_bg(name, factor)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })

    local fg = hl.fg or normal_hl.fg
    if fg == nil or fg == "NONE" then return end

    local bg = hl.bg or normal_hl.bg
    if bg == nil or bg == "NONE" then return end

    local bg_rgb = M.blend(bg, fg, factor)
    local bg_hex = M.format(bg_rgb, "hex")
    vim.api.nvim_set_hl(0, name, { bg = bg_hex, default = false, update = true })
end

return M
