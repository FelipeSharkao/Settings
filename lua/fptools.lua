local M = {}

-- ================= Table =================

--- Creates a new table applying a function to each element.
--- @generic T, U
--- @param list T[] The original table.
--- @param fn fun(item: T): U The function to apply to each element of the original table.
--- @return U[]
M.map = function(list, fn)
    local result = {}
    for _, v in ipairs(list) do
        table.insert(result, fn(v))
    end
    return result
end

--- Creates a new table with the elements that match a given function.
--- @generic T
--- @param list T[] The original table.
--- @param fn fun(item: T): boolean The function to apply to each element of the original table.
--- @return T[]
M.filter = function(list, fn)
    local result = {}
    for _, v in ipairs(list) do
        if fn(v) then
            table.insert(result, v)
        end
    end
    return result
end

--- Finds the index of an element in a table.
--- @generic T
--- @param list T[] The table to search.
--- @param item T The element to search for.
--- @return number | nil
M.index_of = function(list, item)
    for i, v in ipairs(list) do
        if v == item then
            return i
        end
    end
    return nil
end

--- Concatenates two tables.
--- @generic T, U
--- @param list T[] The first table.
--- @param other U[] The second table.
--- @return (T | U)[]
M.concat = function(list, other)
    local result = {}
    for _, v in ipairs(list) do
        table.insert(result, v)
    end
    for _, v in ipairs(other) do
        table.insert(result, v)
    end
    return result
end

-- ================= Function =================

--- Creates a new function that calls the given function with the passed arguments.
--- @generic T
--- @param fn fun(...: any): T The function to call.
--- @param ... any The arguments to pass to the function.
--- @return fun(...: any): T
M.apply = function(fn, ...)
    local applied_args = { ... }
    return function(...)
        return fn(unpack(M.concat(applied_args, { ... })))
    end
end

return M
