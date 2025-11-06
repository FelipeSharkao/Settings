return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "c",
                "lua",
                "markdown",
                "markdown_inline",
                "query",
                "vim",
                "vimdoc",
                "javascript",
                "typescript",
            },
            auto_install = true,
            sync_install = false,
            ignore_install = {},
            highlight = { enable = true },
            indent = { enable = false },
            endwise = { enable = true },
            modules = {},
        })
    end,
}
