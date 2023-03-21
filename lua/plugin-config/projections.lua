local projections = require("projections")
local telescope = require("telescope")

projections.setup({
    store_hooks = {
        pre = function()
            -- Handle nvim-tree
            local tree_api = require("nvim-tree.api")
            tree_api.tree.close()

            -- Stop LSP to free up memory
            vim.lsp.stop_client(vim.lsp.get_active_clients())
        end,
    },
})

vim.opt.sessionoptions:append("localoptions")

-- Auto-store session on exit
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    callback = function()
        local session = require("projections.session")
        session.store(vim.loop.cwd())
    end,
})

-- Add workspace command
vim.api.nvim_create_user_command("AddWorkspace", function(data)
    local workspace = require("projections.workspace")
    workspace.add(data.args or vim.loop.cwd())
end, { nargs = "?" })

-- Telescope integration
telescope.load_extension("projections")

vim.keymap.set("n", "<Leader>p", function()
    vim.cmd("Telescope projections")
end)