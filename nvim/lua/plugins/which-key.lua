require("lazy")

---@type LazySpec
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@type wk.Opts
    opts = {
        spec = {
            { "gf", desc = "Telescope" },
            { "gr", desc = "LSP actions" },
            { "gs", desc = "LSP navigation" },
            { "<Leader>h", desc = "Gitsigns" },
        },
        triggers = {
            { "<auto>", mode = "nxso" },
            { "s", mode = "nx" },
        },
    },
    keys = {
        {
            "<leader>?",
            function() require("which-key").show({ global = false }) end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
