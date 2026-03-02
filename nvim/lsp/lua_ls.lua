local utils = require("plugin-utils")

return utils.lsp.extend_config({
    settings = {
        Lua = {
            runtime = { version = "LuaJIT", pathStrict = false },
        },
    },
}, { no_format = true })
