local utils = require("plugin-utils")

local lang_settings = {
    inlayHints = {
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
    },
    preferences = {
        preferTypeOnlyAutoImports = true,
    },
}

return utils.lsp.extend_config({
    settings = {
        publish_diagnostic_on = "insert_leave",
        typescript = lang_settings,
        javascript = lang_settings,
        vtsls = { experimental = { entriesLimit = 30 } },
    },
}, { no_format = true })
