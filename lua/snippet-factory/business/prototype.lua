local lib_get_text = require "snippet-factory.lib.get_text"
local fmt = require "snippet-factory.lib.fmt"

local M = {}

M.create_snippet = function(placeholder, trigger)
    local args = {
        trigger = trigger,
        body = lib_get_text.get_selection_text({ dedent = true }),
    }

    return fmt(placeholder, args, { replace_curly_braces = true })
end

M.input_trigger_then_create_snippet = function()
    local snippet_skeleton = [[
cs({{
    trigger = "{trigger}",
    nodes = fmt(
    [=[
{body}
]=]),
    target_table = snippets,
}})
]]

    local args = {
        trigger = "____",
        body = lib_get_text.get_selection_text({ dedent = true }),
    }

    vim.ui.input(
        { prompt = "Please enter Trigger for this Snippet" },
        function(trigger)
            args.trigger = trigger

            local snippet_content =
                fmt(snippet_skeleton, args, { replace_curly_braces = true })

            N(snippet_content)
        end
    )
end

vim.keymap.set("x", "<leader>x", function()
    M.input_trigger_then_create_snippet()
end, {})

return M

-- {{{nvim-execute-on-save}}}
