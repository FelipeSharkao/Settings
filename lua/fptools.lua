-- ================= Table =================

--- Creates a new table with the elements that match a given function.
--- @generic T
--- @param list T[] The original table.
--- @param fn fun(item: T): boolean The function to apply to each element of the original table.
--- @return T[]
local function filter(list, fn)
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
local function index_of(list, item)
    for i, v in ipairs(list) do
        if v == item then
            return i
        end
    end
    return nil
end

--- Cocatenates two tables.
--- @generic T, U
--- @param list T[] The first table.
--- @param other U[] The second table.
--- @return (T | U)[]
local function concat(list, other)
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
local function apply(fn, ...)
    local applied_args = { ... }
    return function(...)
        return fn(unpack(concat(applied_args, { ... })))
    end
end

return {
    filter = filter,
    index_of = index_of,
    concat = concat,
    apply = apply,
}
