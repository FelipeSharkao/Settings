---@type LazySpec[]
return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            { "dcampos/cmp-snippy", dependencies = { "dcampos/nvim-snippy" } },
            "onsails/lspkind.nvim",
        },
        init = function() vim.o.pumheight = 5 end,
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args) require("snippy").expand_snippet(args.body) end,
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-j>"] = cmp.mapping.scroll_docs(4),
                    ["<C-x><C-o>"] = cmp.mapping.complete({}),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                },
                sources = cmp.config.sources({
                    { name = "snippy", max_item_count = 3 },
                    { name = "nvim_lsp", max_item_count = 5 },
                    { name = "buffer", max_item_count = 5 },
                }),
                performance = {
                    debounce = 0,
                    throttle = 0,
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        vim_item = lspkind.cmp_format({
                            mode = "symbol",
                            maxwidth = 50,
                            ellipsis_char = "...",
                        })(entry, vim_item)

                        if
                            entry.completion_item.detail ~= nil
                            and entry.completion_item.detail ~= ""
                        then
                            vim_item.menu = entry.completion_item.detail
                        end

                        return vim_item
                    end,
                },
            })

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources(
                    { { name = "path" } },
                    { { name = "cmdline" } }
                ),
            })
        end,
    },
    {
        "dcampos/nvim-snippy",
        event = "InsertEnter",
        opts = {
            mappings = {
                is = {
                    ["<C-l>"] = "expand_or_advance",
                    ["<C-h>"] = "previous",
                },
            },
        },
    },
    "honza/vim-snippets",
}
