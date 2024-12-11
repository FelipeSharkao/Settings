return {
    {
        dir = "~/Projects/lang/editor-plugins/nvim",
        name = "nasin",
        opts = {},
        build = function()
            require("nasin").build()
        end,
    },
}
