local lib_get_text = require "snippet-factory.lib.get_text"
local fmt = require "snippet-factory.lib.fmt"

local M = {}

M.create_snippet = function(placeholder, trigger)
    local slots = {
        trigger = trigger,
        body = lib_get_text.get_selection_text(),
    }

    return fmt(placeholder, slots, { replace_curly_braces = true })
end

return M
