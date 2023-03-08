local fp = require("fptools")

local M = {}

--- @class DialogOptions
--- @field prompt string The prompt to show.

--- Shows a dialog popup.
--- @param choices string[] The choices to show.
--- @param options DialogOptions The options to use.
--- @param callback fun(choice: string) The callback to call when a choice is selected.
M.dialog = function(choices, options, callback)
    choices = fp.map(choices, function(item)
        local i, j = item:find("&%w")
        if i ~= nil and j ~= nil then
            return item:sub(1, i - 1) .. "(" .. item:sub(i + 1, j) .. ")" .. item:sub(j + 1)
        end
        return item
    end)

    vim.ui.select(choices, { prompt = options.prompt }, function(choice)
        callback(choice)
    end)
end

return M
