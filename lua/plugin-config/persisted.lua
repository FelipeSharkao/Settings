local function should_autosave()
    local files = vim.fn.readdir(vim.fn.getcwd())

    for _, file in ipairs(files) do
        if file == ".git" or file == "package.json" or file == "Cargo.toml" then
            return true
        end
    end

    return false
end

require("persisted").setup({
    should_autosave = should_autosave,
})

vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

require("telescope").load_extension("persisted")

vim.keymap.set("n", "<Leader>p", function()
    vim.cmd("Telescope persisted")
end)

vim.api.nvim_create_autocmd("User", {
    pattern = "PersistedTelescopeLoadPre",
    callback = function()
        if should_autosave() then
            vim.cmd("SessionSave")
        end

        vim.cmd("silent! bufdo! noa bwipeout!")
    end,
})

local function update_recent_list()
    local session = vim.g.persisted_loaded_session

    if not session then
        return
    end

    local file_path = vim.fn.stdpath("data") .. "/persisted_recent"

    local file = io.open(file_path, "r")
    local recent_sessions = { session }

    if file then
        for line in file:lines() do
            if #recent_sessions >= 10 then
                break
            end

            if line ~= session then
                table.insert(recent_sessions, line)
            end
        end

        file:close()
    end

    file = io.open(file_path, "w")

    if file then
        for _, line in ipairs(recent_sessions) do
            file:write(line .. "\n")
        end

        file:close()
    end
end

vim.api.nvim_create_autocmd("User", {
    pattern = { "PersistedLoadPost", "PersistedTelescopeLoadPost", "PersistedSavePre" },
    callback = function()
        -- persisted seems to have a bug that I couldn't reproduce to open a issue, where the
        -- session is saved to the wrong file if loaded by telescope, singe this
        -- `vim.g.persisting_session` is set to the wrong value, so we set it to the correct value here
        vim.g.persisting_session = nil

        update_recent_list()
    end,
})

vim.api.nvim_create_user_command("Open", function(cmd)
    if should_autosave() then
        vim.cmd("SessionSave")
    end

    vim.cmd("SessionStop")

    vim.cmd("cd " .. cmd.args)
    vim.cmd("%bwipeout!")

    vim.cmd("SessionLoad")
end, { nargs = 1, complete = "dir" })
