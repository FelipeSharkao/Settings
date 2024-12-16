return {
    {
        dir = "~/Projects/nasin/nasin-nvim",
        name = "nasin",
        opts = {},
        build = function()
            require("nasin").build()
        end,
    },
}
