-- mini.nvim adds a lot of modolar features, improving the general experience

-- Extends a/i textobjects
require("mini.ai").setup()

-- Highlight the word under the cursor
require("mini.cursorword").setup()

-- Opinated statusline
require("mini.statusline").setup()

-- Surround actions
require("mini.surround").setup({
    mappings = {
        add = "ys",
        delete = "ds",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "cs",
        update_n_lines = "gss",
    },
})

-- Startup screen
local starter = require("mini.starter")
local prefixes = "zx"
local labels = "fgdsatrewquiopnmvcyb"
starter.setup({
    evaluate_single = true,
    header = require("utils").quotes.cowsay(),
    footer = "",
    items = {
        { section = "", name = "New File", action = "enew" },
        { section = "", name = "Quit", action = "qa" },

        -- Recent sessions
        function()
            local home = vim.fn.expand("$HOME/")
            local file = io.open(vim.fn.stdpath("data") .. "/persisted_recent", "r")

            if not file then
                return {}
            end

            local entries = {}

            for line in file:lines() do
                local name = line:gsub(".*/", "")
                    :gsub(".vim$", "")
                    :gsub("%%", "/")
                    :gsub("^" .. home, "")
                    :gsub("@@(.*)", " (branch: %1)")

                table.insert(entries, {
                    section = "Recent sessions",
                    name = name,
                    action = "SessionLoadFromFile " .. line,
                })
            end

            return entries
        end,

        starter.sections.recent_files(10, false),
    },
    content_hooks = {
        starter.gen_hook.padding(3, 2),
        starter.gen_hook.adding_bullet("  "),

        -- index items with letters
        function(content)
            local action_sections = { "" }

            local used_labels = {}

            local i_prefix = 0
            local i_label = 1

            local function use_label(label, prefix)
                local with_prefix = prefix .. label

                if not labels:find(label) or vim.tbl_contains(used_labels, with_prefix) then
                    return nil
                end

                table.insert(used_labels, with_prefix)
                return with_prefix
            end

            local function get_label()
                local label = nil

                repeat
                    local prefix = i_prefix > 0 and prefixes:sub(i_prefix, i_prefix) or ""
                    label = use_label(labels:sub(i_label, i_label), prefix)

                    i_label = i_label + 1
                    if i_label > #labels then
                        i_label = 1
                        i_prefix = i_prefix + 1
                    end
                until label or i_prefix > #prefixes

                return label
            end

            local coords = starter.content_coords(content, "item")

            for _, c in ipairs(coords) do
                local unit = content[c.line][c.unit]
                local item = unit.item

                local label = nil

                if vim.tbl_contains(action_sections, item.section) then
                    local initial = item.name:sub(1, 1):lower()
                    label = use_label(initial, "") or use_label(initial:upper(), "")
                end

                label = label or get_label()

                if label then
                    unit.string = label .. "  " .. unit.string
                end
            end

            return content
        end,
    },
    query_updaters = prefixes .. labels,
})
