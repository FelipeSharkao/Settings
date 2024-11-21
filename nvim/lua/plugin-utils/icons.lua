local M = {}

M.lsp_icons = {
    File = " ",
    Module = " ",
    Namespace = " ",
    Package = " ",
    Class = " ",
    Method = " ",
    Property = " ",
    Field = " ",
    Constructor = " ",
    Enum = " ",
    Interface = " ",
    Function = " ",
    Variable = " ",
    Constant = " ",
    String = " ",
    Number = " ",
    Boolean = " ",
    Array = " ",
    Object = " ",
    Key = " ",
    Null = " ",
    EnumMember = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
}

M.get_icon = function(filename)
    filename = filename or vim.fn.expand("%:t")
    local extension = vim.fn.fnamemodify(filename, ":e")
    return require("nvim-web-devicons").get_icon(filename, extension, { default = true })
end

M.winbar_get_icon = function()
    local file_icon, hl_group = M.get_icon()
    if not file_icon then
        return ""
    end
    if not hl_group then
        return file_icon
    end
    return "%#" .. hl_group .. "#" .. file_icon .. "%*"
end

return M
