return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        local parsers = require("nvim-treesitter.parsers")
        ts.setup()

        local augroup = vim.api.nvim_create_augroup("treesitter-config", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            callback = function(args)
                if parsers[args.match] then
                    ts.install({ args.match }):await(function(err)
                        if not err then vim.treesitter.start() end
                    end)
                end
            end,
        })
    end,
}
