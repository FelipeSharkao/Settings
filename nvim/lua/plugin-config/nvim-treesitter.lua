require("nvim-treesitter.configs").setup({
    -- will install treesitter for all available languages
    ensure_installed = "all",
    highlight = { enable = true },
    indent = { enable = true },
    endwise = { enable = true },
})
