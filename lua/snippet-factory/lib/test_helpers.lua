local M = {}

local lib_strings = require "snippet-factory.lib.strings"

--=============== Text Manipulation in Buffer ===============

function M.set_lines(lines)
    if type(lines) == "string" then
        lines = lib_strings.split_string_to_table(lines)
    end

    return vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

return M
