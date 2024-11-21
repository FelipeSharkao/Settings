require("plugin-utils.string")
local icons = require("plugin-utils.icons")
local quotes = require("plugin-utils.quotes")

return {
    lsp_icons = icons.lsp_icons,
    get_icon = icons.get_icon,
    winbar_get_icon = icons.winbar_get_icon,
    quotes = quotes,
}
