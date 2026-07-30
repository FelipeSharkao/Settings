require("lazy")

local function visual_range() return { vim.fn.line("."), vim.fn.line("v") } end

---@type LazySpec[]
return {
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        opts = {
            current_line_blame = true,
            current_line_blame_opts = { ignore_whitespace = true },
        },
        keys = {
            {
                "[c",
                "<Cmd>Gitsigns nav_hunk prev<CR>",
                desc = "Gitsigns prev hunk",
            },
            {
                "]c",
                "<Cmd>Gitsigns nav_hunk next<CR>",
                desc = "Gitsigns next hunk",
            },
            {
                "[C",
                "<Cmd>Gitsigns nav_hunk first<CR>",
                desc = "Gitsigns first hunk",
            },
            {
                "]C",
                "<Cmd>Gitsigns nav_hunk next<CR>",
                desc = "Gitsigns last hunk",
            },
            {
                "<Leader>hs",
                "<Cmd>Gitsigns stage_hunk<CR>",
                desc = "Gitsigns stage hunk",
            },
            {
                "<Leader>hr",
                "<Cmd>Gitsigns reset_hunk<CR>",
                desc = "Gitsigns reset hunk",
            },
            {
                "<Leader>hs",
                function() require("gitsigns").stage_hunk(visual_range()) end,
                mode = "v",
                desc = "Gitsigns stage lines",
            },
            {
                "<Leader>hr",
                function() require("gitsigns").reset_hunk(visual_range()) end,
                mode = "v",
                desc = "Gitsigns reset lines",
            },
            {
                "<Leader>hS",
                "<Cmd>Gitsigns stage_buffer<CR>",
                desc = "Gitsigns stage buffer",
            },
            {
                "<Leader>hR",
                "<Cmd>Gitsigns reset_buffer<CR>",
                desc = "Gitsigns reset buffer",
            },
            {
                "ih",
                "<Cmd>Gitsigns select_hunk<CR>",
                mode = { "o", "x" },
                desc = "Gitsigns select hunk",
            },
        },
    },
    {
        "sindrets/diffview.nvim",
        opts = {
            view = {
                merge_tool = { layout = "diff3_vertical" },
            },
            default_args = {
                DiffviewFileHistory = { "--no-merges" },
            },
        },
    },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = function()
            require("git-conflict").setup({})

            local utils = require("plugin-utils")
            utils.colors.hl_soften_bg("GitConflictAncestor", 0.6)
            utils.colors.hl_soften_bg("GitConflictAncestorLabel", 0.3)
        end,
    },
}
