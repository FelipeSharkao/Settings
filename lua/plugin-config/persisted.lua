require("persisted").setup({
    autosave = false,
})

vim.o.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"

require("telescope").load_extension("persisted")

vim.keymap.set("n", "<Leader>p", function()
    vim.cmd("Telescope persisted")
end)

local function autosave()
    local files = vim.fn.readdir(vim.loop.cwd())

    for _, file in ipairs(files) do
        if file == ".git" or file == "package.json" or file == "Cargo.toml" then
            vim.cmd("SessionSave")
            break
        end
    end
end

vim.api.nvim_create_autocmd(
    { "VimLeavePre", "BufEnter", "BufDelete", "BufWinEnter", "DirChangedPre" },
    { pattern = "*", callback = autosave }
)

-- vim.api.nvim_create_autocmd("User", {
--     pattern = "PersistedLoadPre",
--     callback = function()
--         autosave()
--         vim.cmd("SessionStop")
--     end,
-- })

vim.api.nvim_create_autocmd("User", {
    pattern = "PersistedTelescopeLoadPre",
    callback = function()
        autosave()
        vim.cmd("SessionStop")
        vim.cmd("silent! bufdo! noa bwipeout!")
    end,
})
