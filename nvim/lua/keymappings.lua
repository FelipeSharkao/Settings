-- defaults
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable arrow keys (git gut)
local arrow_keys = {
    "<Up>",
    "<C-Up>",
    "<Down>",
    "<C-Down>",
    "<Left>",
    "<C-Left>",
    "<Right>",
    "<C-Right>",
    "<PageUp>",
    "<C-PageUp>",
    "<PageDown>",
    "<C-PageDown>",
    "<Home>",
    "<C-Home>",
    "<End>",
    "<C-End>",
}
for _, key in ipairs(arrow_keys) do
    keymap({ "n", "i", "v" }, key, "<Cmd>echo 'Use k, l, f, t, <C-U> or <C-D>'<CR>", opts)
end

-- loclist and quickfix
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        keymap(
            "n",
            "<CR>",
            "<CR><Cmd>cclose<CR>",
            vim.tbl_extend("force", opts, { buffer = 0 })
        )
    end,
})

-- Util commands
vim.api.nvim_create_user_command("Open", function(o)
    vim.cmd("tabe | tcd " .. o.fargs[1])
    require("oil").open(nil, { preview = {} })
end, {
    desc = "Open directory in new tab",
    complete = "dir",
    nargs = 1,
})
vim.api.nvim_create_user_command("Settings", "Open ~/Settings", {
    desc = "Open Settings directory",
})
