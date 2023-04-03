local T = require("utils.table")

local M = {}

--- Creates a new function that calls the given function with the passed arguments.
--- @generic T
--- @param fn fun(...: any): T The function to call.
--- @param ... any The arguments to pass to the function.
--- @return fun(...: any): T
M.apply = function(fn, ...)
    local applied_args = { ... }
    return function(...)
        return fn(unpack(T.concat(applied_args, { ... })))
    end
end

return M
