local lib_get_text = require "snippet-factory.lib.get_text"
local fmt = require "snippet-factory.lib.fmt"

local M = {}

vim.keymap.set("x", "<leader>n", function()
    local placeholder = [[
hello {}
{}]]
    local slots = {
        lib_get_text.get_selection_text(),
        lib_get_text.get_selection_text(),
    }

    local fmt_result = fmt(placeholder, slots)

    N(fmt_result)
end, {})

return M

-- {{{nvim-execute-on-save}}}
