local lib_get_text = require "snippet-factory.lib.get_text"
local fmt = require "snippet-factory.lib.fmt"
local filesystem = require "snippet-factory.lib.filesystem"

local M = {}

--- For testing purposes only
M.__create_snippet_intergration_testing = function(placeholder, trigger)
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
]=], {{}}),
    target_table = snippets,
}})
]]

    local args = {
        body = lib_get_text.get_selection_text({ dedent = true }),
    }

    vim.ui.input(
        { prompt = "Please enter Trigger for this Snippet" },
        function(trigger)
            args.trigger = trigger

            local snippet_content =
                fmt(snippet_skeleton, args, { replace_curly_braces = true })

            local file_path =
                "/home/ziontee113/.config/nvim/snippets/lua/extra.lua"

            filesystem.write_to_file(
                file_path,
                vim.split(snippet_content, "\n")
            )

            require("luasnip.loaders").reload_file(vim.fn.expand(file_path)) -- LuaSnip hot reloading

            -- TODO: use lines as tables instead of concat them to string then split them up again.
        end
    )
end

vim.keymap.set("x", "<leader>x", function()
    M.input_trigger_then_create_snippet()
end, {})

return M

-- {{{nvim-execute-on-save}}}
