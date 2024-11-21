-- defaults
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- clipboard
keymap("n", "+", '"+', opts)
keymap("v", "+", '"+', opts)

-- Disable arrow keys (git gut)
local arrow_keys = { "<Up>", "<Down>", "<Left>", "<Right>", "<PageUp>", "<PageDown>" }
for _, key in ipairs(arrow_keys) do
    keymap(
        { "n", "i", "v" },
        key,
        "<Cmd>echo 'Use k, l, f, t, s, <C-U> or <C-D>'<CR>",
        opts
    )
end

-- use Esc in terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)
-- use Esc to cancel search
keymap("n", "<Esc>", "<Cmd>noh<CR>", opts)

-- create a new line without breaking the current one
keymap("i", "<C-CR>", "<C-O>o", opts)
keymap("i", "<C-S-CR>", "<C-O>O", opts)

-- tabs
keymap("n", "[t", "<Cmd>tabp<CR>", opts)
keymap("n", "]t", "<Cmd>tabn<CR>", opts)

-- loclist and quickfix
keymap("n", "]l", "<Cmd>lnext<CR>", opts)
keymap("n", "[l", "<Cmd>lprev<CR>", opts)
keymap("n", "]q", "<Cmd>cnext<CR>", opts)
keymap("n", "[q", "<Cmd>cprev<CR>", opts)
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
vim.api.nvim_create_user_command("Lua", function(params)
    vim.cmd("lua print(vim.inspect(" .. params.args .. "))")
end, { nargs = "+", complete = "lua" })
