return {
    {
        "https://github.com/kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        build = function()
            require("dbee").install()
        end,
        config = function()
            require("dbee").setup({
                sources = {
                    require("dbee.sources").FileSource:new(
                        vim.fn.stdpath("cache") .. "/dbee/connections.json"
                    ),
                },
            })
        end,
        lazy = true,
        cmd = { "Dbee" },
    },
}
