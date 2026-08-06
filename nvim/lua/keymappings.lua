-- defaults
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- emacs/readline keys on insert and command mode
for _, key in ipairs({
    { "<C-b>", "<Left>", desc = "Move cursor one character to the left" },
    { "<C-f>", "<Right>", desc = "Move cursor one character to the right" },
    { "<C-BS>", "<C-W>", desc = "Delete the next word" },
}) do
    keymap({ "i", "c" }, table.remove(key, 1), table.remove(key, 1), key)
end
for _, key in ipairs({
    { "<M-b>", "b", desc = "Move cursor one word to the left" },
    { "<M-f>", "w", desc = "Move cursor one word to the right" },
    { "<M-d>", "de", desc = "Delete the next word" },
    { "<C-Del>", "de", desc = "Delete the next word" },
    { "<C-k>", "D", desc = "Delete the text up to the end of the line" },
}) do
    local lhs = table.remove(key, 1)
    local rhs = table.remove(key, 1)
    keymap("i", lhs, function()
        local ve = vim.wo.virtualedit
        vim.opt_local.virtualedit:append("onemore")
        vim.cmd.normal({ rhs, bang = true })
        vim.wo.virtualedit = ve
    end, key)
end

-- loclist and quickfix
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = function()
        keymap(
            "n",
            "<CR>",
            "<CR><Cmd>cclose<CR><Cmd>lclose<CR>",
            vim.tbl_extend("force", opts, { buffer = 0 })
        )
    end,
})

for _, cmd in ipairs({ "WriteSudo", "Wsu" }) do
    vim.api.nvim_create_user_command(cmd, function(o)
        local file = o.fargs[1] or vim.fn.expand("%")
        vim.cmd("w !pkexec tee " .. file .. " > /dev/null")
        print('"' .. file .. '" written as root')
        vim.cmd("e! " .. file)
        vim.bo.readonly = false
    end, {
        desc = "Write file as root",
        nargs = "?",
        complete = "file",
    })
end

-- Restart session
for _, cmd in ipairs({ "RestartSession", "Rso" }) do
    vim.api.nvim_create_user_command(cmd, function(o)
        local file = o.fargs[1] or vim.fn.stdpath('cache') .. 'Session.vim'
        vim.cmd.mksession({ file, bang = true })
        vim.cmd.restart("source", file)
    end, {
        desc = "Restart preserving current session",
        nargs = "?",
        complete = "file",
    })
end

-- Treesitter queries development
vim.api.nvim_create_user_command("SaveHighlights", function(o)
    local lang = o.fargs[1]

    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    local path = vim.fn.stdpath("data") .. "/site/queries/" .. lang .. "/highlights.scm"

    vim.treesitter.query.set(lang, "highlights", content)
    io.open(path, "w"):write(content)
end, {
    desc = "Save highlights.scm for a parser",
    nargs = 1,
    complete = function() return vim.tbl_keys(require("nvim-treesitter.parsers")) end,
})
