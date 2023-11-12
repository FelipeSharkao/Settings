local dap = require("dap")
local dapui = require("dapui")
local opts = { silent = true, noremap = true }
local keymap = vim.keymap.set

require("dap-vscode-js").setup({
    debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
    adapters = { "pwa-node", "pwa-chrome", "node-terminal" },
})

for _, language in ipairs({ "typescript", "javascript" }) do
    require("dap").configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
        },
    }
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

vim.api.nvim_create_user_command("DapAttachToCwd", function(opts)
    print("Attaching debugger")
    dap.run({
        type = opts.args,
        request = "attach",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        skipFiles = { "<node_internals>/**/*.js" },
    })
end, { nargs = 1 })

keymap("n", "<C-d>n", dap.continue, opts)
keymap("n", "<C-d>k", dap.step_out, opts)
keymap("n", "<C-d>j", dap.step_into, opts)
keymap("n", "<C-d>l", dap.step_over, opts)
keymap("n", "<C-d>h", dapui.float_element, opts)

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end
