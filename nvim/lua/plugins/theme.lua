return {
    { "bjarneo/aether.nvim", branch = "v3", opts = {} },
    {
        "raddari/last-color.nvim",
        init = function()
            local theme = require("last-color").recall() or "aether"
            vim.cmd("colorscheme " .. theme)
        end,
    },
}
