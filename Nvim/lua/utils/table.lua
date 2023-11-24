--- Finds the index of an element in a table.
--- @param item any The element to search for.
--- @param list any[] The table to search.
--- @return number | nil
vim.tbl_index = function(item, list)
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
vim.tbl_concat = function(list, other)
    local result = {}
    for _, v in ipairs(list) do
        table.insert(result, v)
    end
    for _, v in ipairs(other) do
        table.insert(result, v)
    end
    return result
end
