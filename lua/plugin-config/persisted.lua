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
