require("lazy")

local function directories_picker()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local picker_opts = {
        prompt_title = "Find directory",
        finder = finders.new_oneshot_job({ "fd", "--type", "d" }, {}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd.Dir(selection[1])
            end)
            return true
        end,
        sorter = conf.file_sorter(),
    }

    pickers.new({}, picker_opts):find()
end

---@type LazySpec
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-dap.nvim",
        { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    },
    config = function()
        local actions = require("telescope.actions")
        local previewers = require("telescope.previewers")
        local sorters = require("telescope.sorters")
        local telescope = require("telescope")
        local lga_actions = require("telescope-live-grep-args.actions")

        local function buf_delete_action(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            current_picker:delete_selection(
                function(selection) require("mini.bufremove").delete(selection.bufnr) end
            )
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
                        ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
                        ["<C-q>"] = actions.close,
                        ["<CR>"] = actions.select_default,
                    },
                    n = {
                        ["<C-n>"] = actions.move_selection_next,
                        ["<C-p>"] = actions.move_selection_previous,
                        ["<C-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
                        ["<C-q>"] = actions.close,
                        ["q"] = actions.close,
                    },
                },
            },
            pickers = {
                buffers = {
                    ignore_current_buffer = true,
                    sort_mru = true,
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
            extensions = {
                live_grep_args = {
                    auto_quoting = true,
                    mappings = {
                        i = {
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({
                                postfix = " --iglob ",
                            }),
                            ["<C-space>"] = lga_actions.to_fuzzy_refine,
                        },
                    },
                },
            },
        })

        telescope.load_extension("dap")
        telescope.load_extension("live_grep_args")

        vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
    end,
    keys = {
        { "gf", "<Nop>" },
        {
            "gff",
            "<Cmd>Telescope find_files<CR>",
            mode = { "n" },
            desc = "Telescope - Find files",
        },
        {
            "gfd",
            directories_picker,
            desc = "Telescope - Find directory",
        },
        {
            "gfg",
            "<Cmd>Telescope live_grep_args<CR>",
            desc = "Telescope - Grep",
        },
        {
            "gfb",
            "<Cmd>Telescope buffers<CR>",
            desc = "Telescope - Buffers",
        },
        {
            "gfl",
            "<Cmd>Telescope resume<CR>",
            desc = "Telescope - Resume previous picker",
        },
    },
}
