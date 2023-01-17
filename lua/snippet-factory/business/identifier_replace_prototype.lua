local lib_get_text = require "snippet-factory.lib.get_text"
local fmt = require "snippet-factory.lib.fmt"

local M = {}

M.create_snippet_with_identifiers_replaced = function(placeholder, trigger)
    local body_text = lib_get_text.get_selection_text({ dedent = true })

    -- TODO: extract body_text's replaced contents into Insert Nodes
    -- TODO: parse body_text into tree-sitter nodes
    local node_text_tbl = {}

    local lang = "lua"
    local query = [[
    ;; query
    ((identifier) @cap)
]]

    local lang_tree = vim.treesitter.get_string_parser(
        body_text,
        lang,
        { injections = { [lang] = "" } }
    )
    local root = lang_tree:parse()[1]:root()

    local iter_query = vim.treesitter.query.parse_query(lang, query)
    for _, matches, _ in iter_query:iter_matches(root) do
        local tsnode = matches[1]
        local node_text = vim.treesitter.get_node_text(tsnode, 0)
        local start_row, start_col, end_row, end_col = tsnode:range()

        table.insert(node_text_tbl, node_text)
        replace_range({
            start_row,
            start_col,
            end_row,
            end_col,
        })

        -- TODO: now we have the `node_text`, `start_row, start_col, end_row, end_col`
        -- what do we do with them?
        -- 1. select the range using `start_row, start_col, end_row, end_col`,
        --    replace that range with curly braces {}
        -- 2. we have the `node_text`, create Insert Nodes like:
        -- i(1, "myvar") --> join that table, then give it to the {nodes} placeholder

        print(node_text)
        print(vim.inspect({ start_row, start_col, end_row, end_col }))
    end

    -- TODO: replace body_text with curly braces {}

    local args = {
        trigger = trigger,
        body = body_text,
        nodes = nodes,
    }

    return fmt(placeholder, args, { replace_curly_braces = true })
end

return M
