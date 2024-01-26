local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-N>"] = cmp.mapping.select_next_item(),
        ["<C-P>"] = cmp.mapping.select_prev_item(),
        ["<C-D>"] = cmp.mapping.scroll_docs(-4),
        ["<C-U>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-C>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources(
        { { name = "nvim_lsp" }, { name = "vsnip" } },
        { { name = "buffer" } }
    ),
    formatting = {
        fields = { "kind", "abbr" },
        format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
        }),
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
