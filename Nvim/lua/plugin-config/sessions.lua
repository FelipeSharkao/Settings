local M = {}

M.sessions_dir = vim.fn.stdpath("data") .. "/sessions"
M.recent_sessions_file = vim.fn.stdpath("data") .. "/recent_sessions"

M.should_autosave = function()
    local files = vim.fn.readdir(vim.fn.getcwd())

    for _, file in ipairs(files) do
        if file == ".git" or file == "package.json" or file == "Cargo.toml" then
            return true
        end
    end

    return false
end

--- @param session_file string
M.load_session = function(session_file)
    vim.cmd("SessionLoadFromFile " .. session_file)
end

--- @param session_file string
--- @return string|nil
M.get_session_cwd = function(session_file)
    local file = io.open(session_file, "r")

    if not file then
        return
    end

    --- @type string|nil
    local cwd

    for line in file:lines() do
        if line:sub(1, 3) == "cd " then
            cwd = vim.fn.expand(line:sub(4))
            break
        end
    end

    file:close()

    return cwd
end

M.sessions = function()
    local sessions = vim.fn.readdir(M.sessions_dir)

    return vim.tbl_map(function(session)
        return M.sessions_dir .. "/" .. session
    end, sessions)
end

M.recent_sessions = function()
    local curr_session = vim.g.persisted_loaded_session

    local file = io.open(M.recent_sessions_file, "r")
    local recent_sessions = curr_session and { curr_session } or {}

    if file then
        for line in file:lines() do
            if line ~= curr_session then
                table.insert(recent_sessions, line)
            end
        end

        file:close()
    end

    return recent_sessions
end

M.update_sessions = function()
    local sessions = M.sessions()

    for _, session in ipairs(sessions) do
        local cwd = M.get_session_cwd(session)

        if not cwd or vim.fn.isdirectory(cwd) ~= 1 then
            vim.fn.delete(session)
        end
    end

    local recent_sessions = M.recent_sessions()

    local file = io.open(M.recent_sessions_file, "w")

    if file then
        for _, session in ipairs(recent_sessions) do
            if vim.fn.filereadable(session) == 1 then
                file:write(session .. "\n")
            end
        end

        file:close()
    end
end

require("persisted").setup({
    should_autosave = M.should_autosave,
})

vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

require("telescope").load_extension("persisted")

vim.keymap.set("n", "<Leader>p", function()
    vim.cmd("Telescope persisted")
end)

vim.api.nvim_create_autocmd("User", {
    pattern = "PersistedTelescopeLoadPre",
    callback = function()
        if M.should_autosave() then
            vim.cmd("SessionSave")
        end

        vim.cmd("silent! bufdo! noa bwipeout!")
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = { "PersistedLoadPost", "PersistedTelescopeLoadPost", "PersistedSavePre" },
    callback = function()
        -- persisted seems to have a bug that I couldn't reproduce to open a issue, where the
        -- session is saved to the wrong file if loaded by telescope, singe this
        -- `vim.g.persisting_session` is set to the wrong value, so we set it to the correct value here
        vim.g.persisting_session = nil

        M.update_sessions()
    end,
})

vim.api.nvim_create_user_command("Open", function(cmd)
    if M.should_autosave() then
        vim.cmd("SessionSave")
    end

    vim.cmd("SessionStop")

    vim.cmd("cd " .. cmd.args)
    vim.cmd("%bwipeout!")

    vim.cmd("SessionLoad")
end, { nargs = 1, complete = "dir" })

return M
