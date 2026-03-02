local M = {}

---@param str string
---@return table<string, string>
function M.parse_env(str)
    local env = {}
    local key = ""
    local value = ""
    local state = "key"
    local escape = false
    for i = 1, #str do
        local c = str:sub(i, i)
        if state == "key" and c:match("%s") then
            if key ~= "" then error("Invalid environment variable: " .. key) end
        elseif state == "key" and c == "=" then
            state = "value"
        elseif state == "key" then
            key = key .. c
        elseif
            (
                (state == "value" and c:match("%s"))
                or (state == "qvalue" and c == "'")
                or (state == "dqvalue" and c == '"')
            ) and not escape
        then
            env[key] = value
            key = ""
            value = ""
            state = "key"
        elseif state == "value" and c == "'" then
            if value ~= "" then error("Invalid environment variable: " .. key) end
            state = "qvalue"
        elseif state == "value" and c == '"' then
            if value ~= "" then error("Invalid environment variable: " .. key) end
            state = "dqvalue"
        elseif
            (state == "value" or state == "qvalue" or state == "dqvalue")
            and c == "\\"
            and not escape
        then
            escape = true
        elseif state == "value" or state == "qvalue" or state == "dqvalue" then
            local special = { ["n"] = "\n", ["r"] = "\r", ["t"] = "\t" }
            if escape and special[c] then
                value = value .. special[c]
            else
                value = value .. c
            end
            escape = false
        end
    end
    return env
end

return M
