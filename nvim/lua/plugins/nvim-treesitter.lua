return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        local async = require("nvim-treesitter.async")
        local parsers = require("nvim-treesitter.parsers")

        ts.setup()

        local ensure_installed = async.async(function(lang)
            local installed = pcall(vim.treesitter.language.inspect, lang)
            if installed then return end
            async.await(ts.install({ lang }))
        end)

        local install_injections = async.async(function(lang)
            local q = vim.treesitter.query.get(lang, "injections")
            if not q then return end
            local tasks = {}
            for _, preds in pairs(q.info.patterns) do
                for _, pred in ipairs(preds) do
                    if pred[1] == "set!" and pred[2] == "injection.language" then
                        -- pred[3] is the injected language name
                        table.insert(tasks, ensure_installed(pred[3]))
                    end
                end
            end
            if #tasks == 0 then return false end
            async.await(async.join(tasks))
            return true
        end)

        local augroup = vim.api.nvim_create_augroup("treesitter-config", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not parsers[lang] then return end
                async.arun(function()
                    async.await(ensure_installed(lang))
                    vim.treesitter.start(args.buf)
                    if async.await(install_injections(lang)) then
                        vim.treesitter.start(args.buf)
                    end
                end)
            end,
        })
    end,
}
