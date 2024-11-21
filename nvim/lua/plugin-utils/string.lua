--- Pad the end of a string to a given length.
--- @param str string The string to pad.
--- @param len number The length to pad to.
--- @param char string The character to pad with.
--- @return string
string.pad_right = function(str, len, char)
    return str .. string.rep(char, len - #str)
end

--- Pad the start of a string to a given length.
--- @param str string The string to pad.
--- @param len number The length to pad to.
--- @param char string The character to pad with.
--- @return string
string.pad_left = function(str, len, char)
    return string.rep(char, len - #str) .. str
end

--- Pad the start and end of a string to a given length.
--- @param str string The string to pad.
--- @param len number The length to pad to.
--- @param char string The character to pad with.
--- @return string
string.pad = function(str, len, char)
    local pad_len = len - #str
    return str:pad_left(math.floor(pad_len / 2) + #str, char):pad_right(len, char)
end
