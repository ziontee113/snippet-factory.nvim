local M = {}

--------------------------------------------

local lib_selection = require "lua.snippet-factory.lib.selection"
local lib_get_text = require "lua.snippet-factory.lib.get_text"
local lib_strings = require "snippet-factory.lib.strings"

local SnippetSession = {
    fmt_nodes = {},
    fmt_nodes_index = 1,
    fmt_x_line = 0,
    fmt_x_offset = 0,
    fmt_y_offset = 0,

    left_special_delimiter = "{",
    right_special_delimiter = "}",
}
SnippetSession.__index = SnippetSession

function SnippetSession:new(opts)
    local session = setmetatable({}, SnippetSession)

    -- Set body to currently selected text
    local selection_text = lib_get_text.get_selection_text({ dedent = true })
    self.original_body = selection_text
    self.body = selection_text

    return session
end

function SnippetSession:set_body(content)
    self.body = content
end

function SnippetSession:get_body()
    return self.body
end

function SnippetSession:add_placeholder()
    local start_row, start_col, end_row, end_col =
        lib_selection.get_visual_range()
    local visual_text = lib_get_text.get_selection_text({ dedent = true })

    --------------------------------------------

    -- handle x_offset
    if start_row ~= self.x_line then
        self.fmt_x_line = start_row
        self.fmt_x_offset = 0
    end

    -- handle start_col_mod
    local start_col_mod = start_col + 1
    local end_col_mod = end_col

    if self.x_line == start_row then
        start_col_mod = start_col_mod + self.fmt_x_offset
        end_col_mod = end_col_mod + self.fmt_x_offset
    end

    local body_text = lib_strings.replace_range(
        self.original_body,
        self.left_special_delimiter .. self.right_special_delimiter,
        start_row + self.fmt_y_offset + 1,
        start_col_mod,
        end_row + self.fmt_y_offset + 1,
        end_col_mod
    )

    -- offset processing
    self.fmt_y_offset = self.fmt_y_offset - (end_row - start_row)
    if self.fmt_x_line == start_row then
        self.fmt_x_offset = self.fmt_x_offset
            - (end_col - start_col)
            + (#self.left_special_delimiter + #self.right_special_delimiter)
    end

    self:set_body(body_text)

    --------------------------------------------

    -- TODO: refactor and add tests
    local visual_lines = vim.split(visual_text, "\n")
    for i, line in ipairs(visual_lines) do
        visual_lines[i] = string.format('"%s"', line)
    end
    visual_lines[1] = string.format("{%s", visual_lines[1])
    visual_lines[#visual_lines] =
        string.format("%s}", visual_lines[#visual_lines])
    visual_lines = string.format(
        "i(%s, %s),",
        self.fmt_nodes_index,
        table.concat(visual_lines)
    )
    table.insert(self.fmt_nodes, visual_lines)

    self.fmt_nodes_index = self.fmt_nodes_index + 1
end

--------------------------------------------

return {
    SnippetSession = SnippetSession,
}
