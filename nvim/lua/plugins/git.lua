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
    { "akinsho/git-conflict.nvim", version = "*", opts = {} },
}
