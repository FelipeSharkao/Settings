local cmp = require("cmp")
local lspkind = require("lspkind")

vim.o.pumheight = 5

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-N>"] = cmp.mapping.select_next_item(),
        ["<C-P>"] = cmp.mapping.select_prev_item(),
        ["<C-h>"] = cmp.mapping.scroll_docs(-4),
        ["<C-l>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.complete({}),
        ["<C-C>"] = cmp.mapping.abort(),
        ["<C-i>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
        { name = "vsnip", max_item_count = 1 },
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
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})
