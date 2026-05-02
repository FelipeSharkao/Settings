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
