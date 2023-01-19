local lib_strings = require "snippet-factory.lib.strings"
local selection = require "snippet-factory.lib.selection"

local get_selection_lines = function()
    local start_row, start_col, end_row, end_col = selection.get_visual_range()

    local lines = vim.api.nvim_buf_get_text(
        0,
        start_row - 1,
        start_col - 1,
        end_row - 1,
        end_col,
        {}
    )

    return lines
end

local get_selection_text = function(opts)
    opts = opts or {}
    local lines = get_selection_lines()

    if opts.dedent then lines = lib_strings.dedent(lines) end

    return table.concat(lines, "\n")
end

return {
    get_selection_lines = get_selection_lines,
    get_selection_text = get_selection_text,
}
