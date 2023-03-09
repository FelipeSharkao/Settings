local fp = require("fptools")

local opts = { noremap = true, silent = true }

local M = {}

--- @class DialogOptions
--- @field prompt string The prompt to show.

--- Shows a dialog popup.
--- @param choices string[] The choices to show.
--- @param options DialogOptions The options to use.
--- @param callback fun(index: number) The callback to call when a choice is selected.
M.dialog = function(choices, options, callback)
    choices = fp.map(choices, function(item)
        local i, j = item:find("&%w")
        if i ~= nil and j ~= nil then
            return {
                label = item:sub(1, i - 1) .. "(" .. item:sub(i + 1, j) .. ")" .. item:sub(j + 1),
                choice = item:sub(1, i - 1) .. item:sub(i + 1, j) .. item:sub(j + 1),
                key = item:sub(i + 1, j):lower(),
            }
        end
        return { choice = item, key = nil }
    end)

    local Text = require("nui.text")
    local Popup = require("nui.popup")

    local vbox = M.VBox({ align = "center", gap = 1 }, {
        Text(" " .. options.prompt .. " ", "Title"),
        M.Flex(
            { gap = { h = 2, v = 1 }, align = { h = "center" } },
            fp.map(choices, function(choice)
                -- TODO: create highlight groups for this
                return Text(choice.label, "Visual")
            end)
        ),
    })

    local popup = Popup({
        border = { style = "rounded" },
        relative = "editor",
        position = "50%",
        size = {
            width = vbox:width(),
            height = vbox:height(),
        },
        enter = true,
        focusable = false,
        buf_options = {
            buftype = "nofile",
            modifiable = false,
            readonly = true,
        },
    })

    popup:mount()

    local bufnr = popup.bufnr
    local ns_id = -1

    local render = function()
        -- enable changes
        vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
        vim.api.nvim_buf_set_option(bufnr, "readonly", false)

        vbox:create_lines(bufnr, ns_id, 1)

        -- disable changes
        vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
        vim.api.nvim_buf_set_option(bufnr, "readonly", true)
    end

    render()

    local selected = 1

    local confirm = function()
        popup:unmount()
        callback(selected)
    end

    local select = function(index)
        selected = index
        if selected < 1 then
            selected = #choices
        elseif selected > #choices then
            selected = 1
        end
        render()
    end

    local move = function(diff)
        select(selected + diff)
    end

    popup:map("n", "<C-q>", fp.apply(popup.unmount, popup), opts)
    popup:map("n", "<C-w>", fp.apply(popup.unmount, popup), opts)
    popup:map("n", "<CR>", confirm, opts)
    popup:map("n", "<Left>", fp.apply(move, -1), opts)
    popup:map("n", "<Down>", fp.apply(move, 1), opts)
    popup:map("n", "<Up>", fp.apply(move, -1), opts)
    popup:map("n", "<Right>", fp.apply(move, 1), opts)
    popup:map("n", "<C-h>", fp.apply(move, -1), opts)
    popup:map("n", "<C-j>", fp.apply(move, 1), opts)
    popup:map("n", "<C-k>", fp.apply(move, -1), opts)
    popup:map("n", "<C-l>", fp.apply(move, 1), opts)

    for i, choice in ipairs(choices) do
        if choice.key ~= nil then
            local action = function()
                select(i)
                confirm()
            end
            popup:map("n", choice.key:lower(), action, opts)
            popup:map("n", choice.key:upper(), action, opts)
        end
    end

    popup:on({ "BufLeave", "BufWinLeave" }, fp.apply(popup.unmount, popup), { once = true })
end

local shift = function(align, len, max)
    if align == "center" then
        return math.floor((max - len) / 2)
    elseif align == "end" then
        return max - len
    end
    return 0
end

local el_height = function(el)
    if el.height ~= nil then
        return el:height()
    end
    return 1
end

local create_lines = function(el, bufnr, ns_id, linenr_start)
    local Line = require("nui.line")

    local height = el_height(el)
    local width = el:width()

    for i = 0, height - 1 do
        local line = Line()
        line:append(string.rep(" ", width))
        line:render(bufnr, ns_id, linenr_start + i)
    end
end

VBox = nil

local init_vbox = function()
    if VBox ~= nil then
        return
    end

    local Object = require("nui.object")
    VBox = Object("VBox")

    function VBox:init(options, items)
        self._options = {
            align = options.align or "start",
            gap = options.gap or 0,
            width = options.width or nil,
        }
        self._items = items or {}
    end

    function VBox:append(item)
        table.insert(self._items, item)
    end

    function VBox:width()
        if self._options.width ~= nil then
            return self._options.width
        end
        return fp.fold(0, self._items, function(acc, item)
            return math.max(acc, item:width())
        end)
    end

    function VBox:height()
        local total_gap = self._options.gap * (#self._items - 1)
        return fp.fold(0, self._items, function(acc, item)
            return acc + el_height(item)
        end) + total_gap
    end

    function VBox:render(bufnr, ns_id, linenr_start, byte_start)
        local line = linenr_start
        for _, item in ipairs(self._items) do
            local col = byte_start + shift(self._options.align, item:width(), self:width())

            item:render(bufnr, ns_id, line, col)
            line = line + el_height(item) + self._options.gap
        end
    end

    function VBox:create_lines(bufnr, ns_id, linenr_start)
        create_lines(self, bufnr, ns_id, linenr_start)
        self:render(bufnr, ns_id, linenr_start, 0)
    end
end

M.VBox = function(options, items)
    init_vbox()
    return VBox:new(options, items)
end

HBox = nil

local init_hbox = function()
    if HBox ~= nil then
        return
    end

    local Object = require("nui.object")
    HBox = Object("HBox")

    function HBox:init(options, items)
        self._options = {
            align = options.align or "start",
            gap = options.gap or 0,
            width = options.width or nil,
        }
        self._items = items or {}
    end

    function HBox:append(item)
        table.insert(self._items, item)
    end

    function HBox:width()
        local total_gap = self._options.gap * (#self._items - 1)
        return fp.fold(0, self._items, function(acc, item)
            return acc + item:width()
        end) + total_gap
    end

    function HBox:height()
        if self._options.height ~= nil then
            return self._options.height
        end
        return fp.fold(0, self._items, function(acc, item)
            return math.max(acc, item.height and item:height() or 1)
        end)
    end

    function HBox:render(bufnr, ns_id, linenr_start, byte_start)
        local col = byte_start
        for _, item in ipairs(self._items) do
            local line = linenr_start + shift(self._options.align, el_height(item), self:height())

            item:render(bufnr, ns_id, line, col)
            col = col + item:width() + self._options.gap
        end
    end

    function HBox:create_lines(bufnr, ns_id, linenr_start)
        create_lines(self, bufnr, ns_id, linenr_start)
        self:render(bufnr, ns_id, linenr_start, 0)
    end
end

M.HBox = function(options, items)
    init_hbox()
    return HBox:new(options, items)
end

Flex = nil

local init_flex = function()
    if Flex ~= nil then
        return
    end

    local Object = require("nui.object")
    Flex = Object("Flex")

    function Flex:init(options, items)
        self._options = {
            align = {
                h = (options.align or {}).h or "start",
                v = (options.align or {}).v or "start",
            },
            gap = {
                h = (options.gap or {}).h or 0,
                v = (options.gap or {}).v or 0,
            },
            width = options.width or nil,
            height = options.height or nil,
        }
        self._items = items or {}
        self._container = nil
    end

    function Flex:append(item)
        table.insert(self._items, item)
        self._container = nil
    end

    function Flex:width()
        if self._options.width ~= nil then
            return self._options.width
        end
        self:_ensure_container()
        return self._container:width()
    end

    function Flex:height()
        if self._options.height ~= nil then
            return self._options.height
        end
        self:_ensure_container()
        return self._container:height()
    end

    function Flex:render(bufnr, ns_id, linenr_start, byte_start)
        self:_ensure_container()
        self._container:render(bufnr, ns_id, linenr_start, byte_start)
    end

    function Flex:create_lines(bufnr, ns_id, linenr_start)
        self:_ensure_container()
        self._container:create_lines(bufnr, ns_id, linenr_start)
    end

    function Flex:_ensure_container()
        if self._container ~= nil then
            return
        end

        local width = self._options.width
        local height = self._options.height
        local align = self._options.align
        local gap = self._options.gap

        self._container = M.VBox({ align = align.v, gap = gap.v, width = width })

        if #self._items == 0 then
            return
        end

        local hbox = M.HBox({ align = align.h, gap = gap.h, height = height })
        self._container:append(hbox)

        for _, item in ipairs(self._items) do
            if width ~= nil and hbox:width() + item:width() > width then
                hbox = M.HBox({ align = align.h, gap = gap.h, height = height })
                self._container:append(hbox)
            end
            hbox:append(item)
        end
    end
end

M.Flex = function(options, items)
    init_flex()
    return Flex:new(options, items)
end

return M
