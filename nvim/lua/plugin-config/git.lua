require("gitsigns").setup()

require("diffview").setup({
    view = {
        merge_tool = { layout = "diff4_mixed" },
    },
    default_args = {
        DiffviewFileHistory = { "--no-merges" },
    },
})
