-- mini.nvim adds a lot of modular features, improving the general experience

-- Usefull stuff
local extra = require("mini.extra")
extra.setup()

-- Extends a/i textobjects
require("mini.ai").setup()

-- Align text
require("mini.align").setup()

-- Highlight the word under the cursor
require("mini.cursorword").setup()

-- File explorer
require("mini.files").setup({
    options = {
        permanent_delete = false,
    },
})
vim.keymap.set("n", "<Leader>e", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
end)

-- Move selected lines around
require("mini.move").setup()

-- Pickers
require("mini.pick").setup({
    mappings = {
        caret_left = "<C-h>",
        caret_right = "<C-l>",
    },
})

-- Opinated statusline
require("mini.statusline").setup()

-- Surround actions
require("mini.surround").setup({
    mappings = {
      add = 'ys',
      delete = 'ds',
      find = 'fs',
      find_left = 'Fs',
      highlight = 'vs',
      replace = 'cs',
      update_n_lines = '',
    },
    custom_surroundings = {
        ["g"] = {
            input = { "%f[%w_][%w_]+%b<>", "^.-<().*()>$" },
            output = function()
                local type_name = MiniSurround.user_input("Type name")
                if type_name then
                    return { left = type_name .. "<", right = ">" }
                end
            end,
        },
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
