local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")

telescope.setup({
    defaults = {
        -- program to use for searching with its arguments
        find_command = {
            "rg",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "top",
            mirror = true,
        },
        file_sorter = sorters.get_fuzzy_file,
        file_ignore_patterns = { "node_modules/.*" },
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        sorting_strategy = "ascending",
        display_path = true,
        color_devicons = true,
        -- less is bash program for preview file contents
        use_less = true,
        -- use all the colors
        set_env = { ["COLORTERM"] = "truecolor" },
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        buffer_previewer_maker = previewers.buffer_previewer_maker,
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-l>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-q>"] = actions.close,
                ["<CR>"] = function()
                    vim.cmd([[:stopinsert]])
                    vim.cmd([[call feedkeys("\<CR>")]])
                end,
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-l>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-q>"] = actions.close,
                ["q"] = actions.close,
            },
        },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
})

telescope.load_extension("dap")

local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

keymap("n", "<Leader>f", builtin.find_files, opts)
keymap("n", "<Leader>g", builtin.live_grep, opts)
keymap("n", "<Leader>b", builtin.buffers, opts)
keymap("n", "<Leader>l", builtin.resume, opts)
