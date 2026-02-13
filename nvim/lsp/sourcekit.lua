local utils = require("plugin-utils")

return utils.lsp.extend_config({
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
}, { no_format = true })
