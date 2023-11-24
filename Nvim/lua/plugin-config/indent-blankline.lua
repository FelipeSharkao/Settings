require("ibl").setup({
    indent = {
        char = "⋅",
        tab_char = "󰞔",
    },
    scope = {
        char = "▏",
        highlight = { "SpecialKey", "SpecialKey", "SpecialKey" },
        show_start = true,
        show_end = false,
        include = {
            node_type = {
                lua = {
                    "chunk",
                    "do_statement",
                    "while_statement",
                    "repeat_statement",
                    "if_statement",
                    "for_statement",
                    "function_declaration",
                    "function_definition",
                    "table_constructor",
                },
                typescript = {
                    "statement_block",
                    "function",
                    "arrow_function",
                    "function_declaration",
                    "method_definition",
                    "for_statement",
                    "for_in_statement",
                    "catch_clause",
                    "object_pattern",
                    "arguments",
                    "switch_case",
                    "switch_statement",
                    "switch_default",
                    "object",
                    "object_type",
                },
            },
        },
    },
    exclude = {
        filetypes = { "startify" },
    },
})
