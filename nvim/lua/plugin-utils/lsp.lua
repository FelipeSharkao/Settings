local M = {}

---@param server string
---@param on_attach fun(client: vim.lsp.Client, bufnr: integer)
---@return fun(client: vim.lsp.Client, bufnr: integer)
M.extend_on_attach = function(server, on_attach)
    local original_on_attach = vim.lsp.config[server].on_attach
    return function(client, bufnr)
        if original_on_attach ~= nil then original_on_attach(client, bufnr) end
        on_attach(client, bufnr)
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
