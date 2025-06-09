return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            columns = { "icon", "size", "mtime" },
            constrain_cursor = "name",
            default_file_explorer = true,
            delete_to_trash = true,
            float = { padding = 3 },
            keymaps = {
                ["<BS>"] = "actions.parent",
                ["<C-h>"] = "actions.toggle_hidden",
                ["<C-l>"] = "action.send_to_qflist",
                ["<C-q>"] = "actions.close",
                ["q"] = "actions.close",
            },
            preview_win = {
                win_options = { foldenable = false },
            },
            skip_confirm_for_simple_edits = true,
            watch_for_changes = true,
            win_options = { winblend = 15 },
        },
        keys = {
            {
                "gfe",
                function()
                    local oil = require("oil")
                    oil.open_float(nil, {}, function()
                        vim.defer_fn(function() oil.open_preview() end, 50)
                    end)
                end,
                mode = { "n" },
            },
        },
    },
}
