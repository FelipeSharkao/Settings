local M = {}

---@param config vim.lsp.Config
---@param opts? { no_format?: boolean }
---@return vim.lsp.Config
M.extend_config = function(config, opts)
    config = vim.tbl_deep_extend(
        "keep",
        config or {},
        { capabilities = require("cmp_nvim_lsp").default_capabilities() },
    )
    opts = vim.tbl_extend("keep", opts or {}, { no_format = false })

    if opts.no_format then
        local original_on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            M.call_on_attach(original_on_attach, client, bufnr)
        end
    end


    return config
end

---@param on_attach elem_or_list<fun(client: vim.lsp.Client, bufnr: integer)> | nil
---@param client vim.lsp.Client
---@param bufnr integer
M.call_on_attach = function(on_attach, client, bufnr)
    if on_attach == nil then return end
    if type(on_attach) == "function" then on_attach(client, bufnr) end
    for _, x in ipairs(on_attach) do M.call_on_attach(x, client, bufnr) end
end

return M
