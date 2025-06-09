local common = require("lsp.common")

return common.extend_config({
    settings = {
        ["rust-analyzer"] = {
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = { enable = true },
            },
            procMacro = {
                enable = true,
            },
            rustfmt = {
                extraArgs = { "+nightly" },
            },
        },
    },
})
