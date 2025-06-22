vim.opt.rtp:prepend(vim.env.SETTINGS .. "/nvim")

require("gui")
require("basics")
require("lazy-config")
require("plugin-utils")
require("globals")

require("plugin-config/telescope")
require("plugin-config/git")
require("plugin-config/mini")
require("plugin-config/nvim-treesitter")
require("plugin-config/indent-blankline")
require("plugin-config/discord")

require("keymappings")

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
    pattern = "*.porth",
    callback = function()
        vim.bo.filetype = "porth"
        vim.bo.spellcapcheck = ""
    end,
})
