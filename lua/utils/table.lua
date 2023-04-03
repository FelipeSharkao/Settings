local M = {}

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

--- Fold a table into a single value.
--- @generic T, U
--- @param initial U The initial value.
--- @param list T[] The table to fold.
--- @param fn fun(acc: U, item: T): U The function to apply to each element of the table.
--- @return U
M.fold = function(initial, list, fn)
    local acc = initial
    for _, v in ipairs(list) do
        acc = fn(acc, v)
    end
    return acc
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

--- Checks if a table contains an element.
--- @param list any[] The table to search.
--- @param item any The element to search for.
--- @return boolean
M.contains = function(list, item)
    return M.index_of(list, item) ~= nil
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

--- Merge two key-value tables. If a key apears in more than one table, the value of the rightmost
--- table will be used.
--- @param ... table
--- @return table
M.merge = function(...)
    local result = {}
    for _, t in ipairs({ ... }) do
        if type(t) == "table" then
            for k, v in pairs(t) do
                result[k] = v
            end
        end
    end
    return result
end

return M
