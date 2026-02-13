local M = {}

---@param config vim.lsp.Config
---@param opts? { no_format?: boolean }
---@return vim.lsp.Config
M.extend_config = function(config, opts)
    config = vim.tbl_deep_extend(
        "keep",
        config or {},
        { capabilities = require("cmp_nvim_lsp").default_capabilities() }
    )
    opts = vim.tbl_extend("keep", opts or {}, { no_format = false })

    if opts.no_format then
        local original_on_attach = config.on_attach
        config.on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            M.enable_inlay_hints(client, bufnr)
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
    for _, x in ipairs(on_attach) do
        M.call_on_attach(x, client, bufnr)
    end
end

--- @param client vim.lsp.Client
--- @param bufnr integer
M.enable_inlay_hints = function(client, bufnr)
    local tries = 0
    local delays = { 30, 60, 120, 250, 500, 1000, 2000 }

    local function try_enable()
        tries = tries + 1

        if
            client.server_capabilities.inlayHintProvider
            or client.supports_method("textDocument/inlayHint", bufnr)
        then
            -- idk why, but some for servers (sourcekit, lua-ls), inlayHintProvider is nil
            -- even though it's supposed to be filled. lsp-endhints expects it to be set
            -- I hope setting it to an empty table is fine, idk what values it should have
            client.server_capabilities.inlayHintProvider = {}
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        elseif tries < 10 then
            -- some servers (sourcekit) don't answer true to this right away, so
            -- exponential backoff it is
            vim.defer_fn(try_enable, tries * 30)
        end
    end

    try_enable()
end

return M
