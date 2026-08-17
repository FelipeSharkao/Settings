local function overseer_config()
    local overseer = require("overseer")

    local component_dispose = {
        "on_complete_dispose",
        require_view = { "FAILURE" },
        statuses = { "SUCCESS", "FAILURE", "CANCELED" },
        timeout = 300,
    }

    local component_notify = {
        "on_complete_notify",
        statuses = { "SUCCESS", "FAILURE" },
        system = "unfocused",
    }

    local component_parse = {
        "on_output_parse",
        problem_matcher = {
            "$eslint-compact",
            "$tsc",
            "$gcc",
            -- c3c
            {
                pattern = {
                    vim_regexp = "\\v^\\(([^:]+):(\\d+):(\\d+)\\) (Error|Warning|Note): (.*)$",
                    file = 1,
                    line = 2,
                    column = 3,
                    severity = 4,
                    message = 5,
                },
            },
            -- generic
            {
                pattern = {
                    vim_regexp = "\\v\\b([\\w\\/]+):(\\d+)(:(\\d+))?\\b",
                    file = 1,
                    line = 2,
                    column = 4,
                },
            },
            {
                pattern = {
                    vim_regexp = "\\v\\b([\\w\\/]+)\\((\\d+)(,\\s*(\\d+))?\\)\\b",
                    file = 1,
                    line = 2,
                    column = 4,
                },
            },
        },
    }

    ---@param task overseer.TaskDefinition
    ---@param util overseer.TaskUtil
    local function inject_default_components(task, util)
        local params = task.default_component_params or {}
        task.default_component_params = params
        params.errorformat = params.errorformat or vim.o.errorformat

        -- Overseer adds on_complete_restart to vscode "isBackground" tasks
        local is_background = util.has_component(task, "restart_on_save")
            or util.has_component(task, "on_complete_restart")

        if is_background then
            if not util.has_component(task, "on_complete_notify") then
                util.add_component(task, component_notify)
            end

            -- Overseer default on_complete_restart restart of failures, making it
            -- impossible to read and handle errors
            if util.has_component(task, "on_complete_restart") then
                util.add_component(
                    task,
                    { "on_complete_restart", statuses = { "SUCCESS" } }
                )
            end
        else
            if not util.has_component(task, "on_output_parse") then
                util.add_component(task, component_parse)
            end

            if
                not util.has_component(task, "open_output")
                and not util.has_component(task, "on_output_quickfix")
            then
                util.add_component(task, { "open_output", focus = true })
            end
        end

        if not util.has_component(task, "on_complete_dispose") then
            util.add_component(task, component_dispose)
        end
    end

    ---@param cmd string|string[]
    local function run_cmd(cmd, is_background)
        local components = { component_dispose, "on_exit_set_status" }

        if is_background then
            table.insert(components, component_notify)
        else
            table.insert(components, component_parse)
            table.insert(components, { "open_output", focus = true })
        end

        local task = require("overseer").new_task({
            cmd = cmd,
            default_component_params = { errorformat = vim.o.errorformat },
            components = components,
        })
        task:start()
    end

    overseer.add_template_hook({}, inject_default_components)

    vim.api.nvim_create_user_command(
        "Make",
        function(opts) run_cmd(vim.fn.expandcmd(opts.args), false) end,
        {
            desc = "Run a shell command and capture the output",
            complete = "shellcmdline",
            nargs = "*",
        }
    )

    vim.api.nvim_create_user_command(
        "Run",
        function(opts) run_cmd(vim.fn.expandcmd(opts.args), true) end,
        {
            desc = "Run a shell command in the background",
            complete = "shellcmdline",
            nargs = "*",
        }
    )
end

local augroup = vim.api.nvim_create_augroup("overseer-config", { clear = true })
local is_focused_map = {}
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
        local tabnr = vim.fn.tabpagenr()
        local ft = vim.bo.filetype
        if ft == "OverseerList" then
            is_focused_map[tabnr] = true
        elseif ft ~= "OverseerOutput" and is_focused_map[tabnr] then
            vim.defer_fn(function() vim.cmd.OverseerClose() end, 0)
            is_focused_map[tabnr] = false
        end
    end,
})

return {
    {
        "stevearc/overseer.nvim",
        lazy = false,
        config = function()
            require("overseer").setup({
                task_list = {
                    max_height = { 50, 0.5 },
                    keymaps = {
                        ["<C-q>"] = {
                            callback = function()
                                -- this is undocumented, but it's how the builtin keymap works
                                -- I couldn't find a way to get the current task without this
                                local sb =
                                    assert(require("overseer.task_list.sidebar").get())
                                sb:run_action("set quickfix diagnostics")
                                vim.cmd.OverseerClose()
                                vim.cmd.copen()
                            end,
                            desc = "Open task diagnostics in the quickfix",
                        },
                        ["r"] = { "keymap.run_action", opts = { action = "restart" } },
                    },
                    sort = function(a, b)
                        return require("overseer.task_list").sort_newest_first(a, b)
                    end,
                },
            })
            overseer_config()
        end,
        keys = {
            {
                "<Leader>oo",
                "<Cmd>OverseerToggle<CR>",
                desc = "Toggle Overseer Task List",
                mode = "n",
            },
            {
                "<Leader>or",
                "<Cmd>OverseerRun<CR>",
                desc = "Run an Overseer Task",
                mode = "n",
            },
        },
    },
}
