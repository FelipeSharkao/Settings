-- ################# Basic settings ################ --

-- Set global nodejs path
vim.g.node_host_prog = vim.env.HOME .. "/.asdf/shims/node"

-- ================= File management ================= --

-- swapfile has global & local config, eventhough help says otherwise
vim.o.swapfile = false -- can open already open files
vim.bo.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.autoread = true -- auto file change detection

-- Triger `autoread` when files changes on disk
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    callback = function()
        vim.cmd("silent! checktime")
    end,
})

-- ================= Split ================= --

vim.o.splitright = true -- open new vertical split to the right
vim.o.splitbelow = true -- open new horizontal split below

-- ================= Scrolling ================= --

vim.o.scrolloff = 8 -- start scrolling when 8 lines away from margins

-- ================= Indentation ================= --

vim.o.tabstop = 4 -- maximum width of tab character (measured in spaces)
vim.o.shiftwidth = 4 -- size of indent (measured in spaces), should equal tabstop
vim.o.softtabstop = 4 -- should be the same as the other two above
vim.o.expandtab = true -- expand tabs to spaces
vim.o.smartindent = true -- smart indenting on new line for C-like programs
vim.o.autoindent = true -- copy the indentation from previous line
vim.o.smarttab = true -- tab infront of a line inserts blanks based on shiftwidth

-- ================= Number column ================= --

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.o.numberwidth = 3 -- width of number column, 3 for 999 lines

-- ================= Search ================= --

vim.o.ignorecase = true -- Ignorecase when searching
vim.o.incsearch = true -- start searching on each keystroke
vim.o.smartcase = true -- ignore case when lowercase, match case when capital case is used
vim.o.hlsearch = true -- highlight the search results

-- ================= Performance ================= --

vim.o.ttimeoutlen = 10 -- ms to wait for a key code seq to complete

-- ================= Word Wrap ================= --

vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.breakindentopt = "min:40,shift:3,sbr"
vim.o.showbreak = "↳"
vim.wo.colorcolumn = "81,+1"

-- Resize selected window if it's too small
vim.api.nvim_create_autocmd({ "VimResized", "BufEnter", "WinEnter" }, {
    callback = function()
        -- Windows' width are always a little wider than textwidth + numberwidth due to signcolumn,
        -- border, etc. I didn't find a way to calculate this, so I'm using a fixed value.
        local min_width = vim.o.textwidth + vim.o.numberwidth + 10
        local width = vim.api.nvim_win_get_width(0)
        if width < min_width then
            vim.api.nvim_win_set_width(0, min_width)
        end
    end,
})

-- ================= Spell checking ================= --

vim.o.spell = true
vim.o.spelllang = "pt,en"
vim.o.spelloptions = "camel"

-- ================= Widows config ================= --

vim.o.winblend = 15
vim.o.pumblend = 15

-- ================= Misc ================= --

vim.o.history = 10000 -- numbers of entries in history for ':' commands and search patterns (10000 = max)
vim.o.updatetime = 100 -- used for CursorHold event (for document highlighting detection)
vim.o.mouse = "nv" -- allow mouse in normal & visual mode
vim.o.mousemodel = "extend" -- right click extends selection

-- allows hidden buffers
-- this means that a modified buffer doesn't need to be saved when changing
-- tabs/windows.
vim.o.hidden = true

-- set completion mode on command line to be similar to cli
vim.o.wildmode = "list:longest"
