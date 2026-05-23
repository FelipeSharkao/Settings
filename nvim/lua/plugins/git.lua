---@type LazySpec[]
return {
    { "lewis6991/gitsigns.nvim", opts = {} },
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
