local function list_sessions()
    local home = vim.fn.expand("$HOME")
    local file = io.open(vim.fn.stdpath("data") .. "/persisted_recent", "r")

    if not file then
        return {}
    end

    local entries = {}

    for line in file:lines() do
        local name = line:gsub(".*/", "")
            :gsub(".vim$", "")
            :gsub("%%", "/")
            :gsub("^" .. home, "~")
            :gsub("@@(.*)", " (branch: %1)")

        table.insert(entries, {
            line = name,
            cmd = "SessionLoadFromFile " .. line,
        })
    end

    return entries
end

vim.g.startify_lists = {
    { type = list_sessions, header = { "   Sessions" } },
    { type = "files", header = { "   Recent Files" } },
}
