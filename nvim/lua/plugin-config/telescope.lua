local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local telescope = require("telescope")

local function buf_delete_action(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local current_picker = action_state.get_current_picker(prompt_bufnr)

    current_picker:delete_selection(function(selection)
        if vim.api.nvim_buf_get_option(selection.bufnr, "modified") then return false end
        require("mini.bufremove").delete(selection.bufnr)
    end)
end

telescope.setup({
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        layout_strategy = "vertical",
        layout_config = {
            prompt_position = "top",
            mirror = true,
        },
        winblend = 15,
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
    pickers = {
        buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
            only_cwd = true,
            mappings = {
                i = {
                    ["<C-d>"] = buf_delete_action,
                },
                n = {
                    ["d"] = buf_delete_action,
                    ["<C-d>"] = buf_delete_action,
                },
            },
        },
    },
})

telescope.load_extension("dap")

local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

keymap("n", "gf", "<Nop>", opts)
keymap("n", "gff", builtin.find_files, opts)
keymap("n", "gfg", builtin.live_grep, opts)
keymap("n", "gfb", builtin.buffers, opts)
keymap("n", "gfl", builtin.resume, opts)

keymap("n", "z=", builtin.spell_suggest, opts)
