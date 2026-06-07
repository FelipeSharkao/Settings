return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            vim.fn.sign_define(
                "DapBreakpoint",
                { text = "󰑊", texthl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = "󰻂", texthl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapBreakpointRejected",
                { text = "󰻃", texthl = "DapBreakpoint" }
            )
            vim.fn.sign_define(
                "DapStopped",
                { text = "", texthl = "DapStopped", linehl = "DapStoppedLine" }
            )
            vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint" })

            vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "ErrorMsg" })
            vim.api.nvim_set_hl(0, "DapStopped", { link = "Debug" })
            vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "ColorColumn" })
            vim.api.nvim_set_hl(0, "DapLogPoint", { link = "DiagnosticInfo" })

            vim.keymap.set("n", "<Leader>dc", require("dap").continue)
            vim.keymap.set("n", "<Leader>dd", require("dap").run_to_cursor)
            vim.keymap.set("n", "<Leader>dn", require("dap").step_over)
            vim.keymap.set("n", "<Leader>di", require("dap").step_into)
            vim.keymap.set("n", "<Leader>do", require("dap").step_out)
            vim.keymap.set("n", "<Leader>dt", require("dap").toggle_breakpoint)
            vim.keymap.set("n", "<Leader>dr", require("dap").restart)
            vim.keymap.set("n", "<Leader>dq", function()
                require("dap").terminate()
                require("dap-view").close()
            end)
            vim.keymap.set("n", "<Leader>dh", require("dap.ui.widgets").hover)
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
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "js" },
                automatic_installation = true,
            })

            local dap = require("dap")
            local dap_utils = require("dap.utils")
            local utils = require("plugin-utils")

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        vim.fn.stdpath("data")
                            .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                        "${port}",
                    },
                },
            }

            for _, language in ipairs({
                "typescript",
                "javascript",
                "javascriptreact",
                "typescriptreact",
            }) do
                local pwa_common_config = {
                    type = "pwa-node",
                    name = "Launch file",
                    sourceMaps = true,
                    resolveSourceMapLocations = {
                        "${workspaceFolder}/**",
                        "!**/node_modules/**",
                    },
                    autoAttachChildProcesses = true,
                    cwd = "${workspaceFolder}",
                    skipFiles = { "<node_internals>/**", "node_modules/**" },
                }
                dap.configurations[language] = {
                    vim.tbl_deep_extend("force", pwa_common_config, {
                        request = "launch",
                        name = "Launch file",
                        program = function()
                            return dap_utils.pick_file({
                                path = vim.fn.getcwd(),
                                executables = false,
                                filter = ".*%.[mc]?jsx?",
                            })
                        end,
                    }),
                    vim.tbl_deep_extend("force", pwa_common_config, {
                        request = "attach",
                        name = "Attach debugger to --inspect (port 9229)",
                        port = 9229,
                        stopOnEntry = false,
                    }),
                    vim.tbl_deep_extend("force", pwa_common_config, {
                        request = "attach",
                        name = "Attach debugger to existing node process",
                        processId = dap_utils.pick_process,
                    }),
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
                    env = function()
                        local env =
                            utils.parse_env(vim.fn.input("Env: ", "", "environment"))
                        return env
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
        end,
    },
}
