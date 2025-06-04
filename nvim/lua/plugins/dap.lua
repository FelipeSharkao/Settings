return {
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<Leader>dc", function() require("dap").continue() end, mode = { "n" } },
            { "<Leader>dn", function() require("dap").step_over() end, mode = { "n" } },
            { "<Leader>di", function() require("dap").step_into() end, mode = { "n" } },
            { "<Leader>do", function() require("dap").step_out() end, mode = { "n" } },
            {
                "<Leader>dt",
                function() require("dap").toggle_breakpoint() end,
                mode = { "n" },
            },
            { "<Leader>dr", function() require("dap").restart() end, mode = { "n" } },
            {
                "<Leader>dq",
                function()
                    require("dap").terminate()
                    require("dap-view").close()
                end,
                mode = { "n" },
            },
        },
        config = function()
            local dap_vscode = require("dap.ext.vscode")
            dap_vscode.load_launchjs(nil, {})

            vim.fn.sign_define(
                "DapBreakpoint",
                { text = "", texthl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapStopped",
                { text = "", texthl = "DapStopped", linehl = "DapStoppedLine" }
            )

            vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "ErrorMsg" })
            vim.api.nvim_set_hl(0, "DapStopped", { link = "Debug" })
            vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "ColorColumn" })
        end,
    },
    {
        "igorlfs/nvim-dap-view",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("dap-view").setup({})

            local dap = require("dap")
            local dap_view = require("dap-view")

            dap.listeners.before.attach["dapui_config"] = function() dap_view.open() end
            dap.listeners.before.launch["dapui_config"] = function() dap_view.open() end
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = { virt_text_pos = "eol" },
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
            "williamboman/mason.nvim",
            "mxsdev/nvim-dap-vscode-js",
            -- lazy spec to build "microsoft/vscode-js-debug" from source
            {
                "microsoft/vscode-js-debug",
                version = "1.x",
                build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
            },
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {},
            })

            local dap = require("dap")
            local dap_utils = require("dap.utils")

            require("dap-vscode-js").setup({
                debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
                adapters = { "pwa-node", "node-terminal" },
            })

            for _, language in ipairs({
                "typescript",
                "javascript",
                "javascriptreact",
                "typescriptreact",
            }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach debugger to existing `node --inspect` process",
                        sourceMaps = true,
                        resolveSourceMapLocations = {
                            "${workspaceFolder}/**",
                            "!**/node_modules/**",
                        },
                        processId = dap_utils.pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end

            dap.adapters.gdb = {
                type = "executable",
                command = "/usr/bin/gdb",
                args = { "--interpreter=dap" },
            }

            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return dap_utils.pick_file({
                            path = vim.fn.getcwd() .. "/target/debug",
                        })
                    end,
                    args = function()
                        return dap_utils.splitstr(vim.fn.input("Args: ", "", "arglist"))
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
        end,
    },
}
