local function list_sessions()
    local sessions_dir = vim.fn.stdpath("data") .. "/sessions"
    local sessions_files = vim.fn.readdir(sessions_dir)

    local entries = {}

    for _, file in ipairs(sessions_files) do
        local name = file:gsub(".vim$", ""):gsub("%%", "/"):gsub("@@(.*)", " (branch: %1)")

        if name ~= "__LAST__" then
            table.insert(entries, {
                line = name,
                cmd = "SessionLoadFromFile " .. sessions_dir .. "/" .. file,
            })
        end
    end

    return entries
end

vim.g.startify_lists = {
    { type = list_sessions, header = { "   Sessions" } },
    { type = "files", header = { "   Recent Files" } },
}
