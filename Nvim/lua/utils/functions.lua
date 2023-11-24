local M = {}

--- Creates a new function that calls the given function with the passed arguments.
--- @generic T
--- @param fn fun(...: any): T The function to call.
--- @param ... any The arguments to pass to the function.
--- @return fun(...: any): T
M.apply = function(fn, ...)
    local applied_args = { ... }
    return function(...)
        local args = vim.tbl_concat(applied_args, { ... })
        return fn(unpack(args))
    end
end

return M
