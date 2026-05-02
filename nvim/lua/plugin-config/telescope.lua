local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
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

--- This use use a slightly modified version usual globs that I'm calling "partial globs".
--- A pattern is allowed in the middle of the path, as if it was surrounded by a wildcard.
--- So `foo/bar` will match `src/foo/bar.txt` and `prefixfoo/barsuffix`. A pattern that
--- starts with "/" will match the whole path, but still be relative to the CWD, not
--- absolute. Same for patterns that end with "$".
local function normalize_glob(glob)
    local s = glob:sub(1, 1)
    if s == "/" then
        glob = glob:sub(2)
    elseif s ~= "*" then
        glob = "**/*" .. glob
    end

    local e = glob:sub(-1)
    if e == "$" then
        glob = glob:sub(1, -2)
    elseif s == "/" then
        glob = glob .. "**"
    elseif s ~= "*" then
        glob = glob .. "*/**"
    end

    return glob
end

local function live_grep_with_filter()
    local vimgrep_arguments = conf.vimgrep_arguments
    local cwd = vim.uv.cwd()
    local picker_opts = {
        prompt_title = "Live Grep (query  *.glob)",
        finder = finders.new_job(function(prompt)
            if not prompt or prompt == "" then return nil end
            local query, glob = prompt:match("^(.+)  (.*)$")
            local args = vim.deepcopy(vimgrep_arguments)
            if glob then
                glob = normalize_glob(glob)
                vim.list_extend(args, { "--glob=" .. glob, "--", query })
            else
                vim.list_extend(args, { "--", query or prompt })
            end
            return args
        end, make_entry.gen_from_vimgrep(), nil, cwd),
        previewer = conf.grep_previewer({}),
        sorter = sorters.highlighter_only(),
    }

    pickers.new({}, picker_opts):find()
end

local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }

keymap("n", "gf", "<Nop>", opts)
keymap("n", "gff", builtin.find_files, opts)
keymap("n", "gfg", live_grep_with_filter, opts)
keymap("n", "gfb", builtin.buffers, opts)
keymap("n", "gfl", builtin.resume, opts)

keymap("n", "z=", builtin.spell_suggest, opts)

vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
