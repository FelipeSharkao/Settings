local lspconfig_util = require("lspconfig.util")
local utils = require("plugin-utils")

local ocamllsp_augroup = vim.api.nvim_create_augroup("ocamllsp", { clear = true })

-- ocamllsp only checks the built files, so I'll just build them on save
local find_dune_root = lspconfig_util.root_pattern("dune-project")

---@type { [string]: "building" | "queued" | nil }
local dune_jobs = {}

-- since it doesn't do automatically, I'll send a didSave notification to the server for
-- each buffer so it syncs the diagnostics with the built files
local function sync_bufs()
    local bufs = vim.api.nvim_list_bufs()
    for _, buf in ipairs(bufs) do
        if
            vim.api.nvim_buf_is_loaded(buf)
            and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
            and vim.api.nvim_get_option_value("filetype", { buf = buf }) == "ocaml"
        then
            local name = vim.api.nvim_buf_get_name(buf)
            local uri = vim.uri_from_fname(name)
            vim.lsp.buf_notify(
                buf,
                "textDocument/didSave",
                { textDocument = { uri = uri } }
            )
        end
    end
end

local function index_project(root)
    root = root
    if not root then return end

    if dune_jobs[root] ~= nil then
        dune_jobs[root] = "queued"
        return
    end

    dune_jobs[root] = "building"

    vim.system({ "dune", "build", "@ocaml-index" }, { cwd = root }, function()
        if dune_jobs[root] == "queued" then
            vim.schedule(function()
                dune_jobs[root] = nil
                index_project(root)
            end)
        else
            dune_jobs[root] = nil
            vim.schedule(sync_bufs)
        end
    end)
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    pattern = { "*.ml", "*.mli", "dune", "dune-project" },
    group = ocamllsp_augroup,
    callback = function(ev)
        index_project(find_dune_root(ev.file or vim.api.nvim_buf_get_name(0)))
    end,
})

return utils.lsp.extend_config({}, { no_format = true })
