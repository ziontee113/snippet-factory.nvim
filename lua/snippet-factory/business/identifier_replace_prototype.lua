local lib_get_text = require "snippet-factory.lib.get_text"
local lib_strings = require "lua.snippet-factory.lib.strings"
local fmt = require "snippet-factory.lib.fmt"

local M = {}

M.create_snippet_with_identifiers_replaced =
    function(placeholder, trigger, query)
        local left_special_delimiter = "𓊆"
        local right_special_delimiter = "𓊇"

        local body_text = lib_get_text.get_selection_text({ dedent = true })
        local insert_nodes = {}

        -- Treesitter magic
        local lang = "lua"

        local lang_tree = vim.treesitter.get_string_parser(
            body_text,
            lang,
            { injections = { [lang] = "" } }
        )
        local root = lang_tree:parse()[1]:root()

        local node_count = 1
        local iter_query = vim.treesitter.query.parse_query(lang, query)
        for _, matches, _ in iter_query:iter_matches(root) do
            local tsnode = matches[1]
            local node_text = vim.treesitter.get_node_text(tsnode, 0)
            local start_row, start_col, end_row, end_col = tsnode:range()

            ---@diagnostic disable-next-line: cast-local-type
            body_text = lib_strings.replace_range(
                body_text,
                left_special_delimiter .. right_special_delimiter,
                start_row + 1,
                start_col + 1,
                end_row + 1,
                end_col
            )

            if string.find(node_text, "\n") then node_text = "" end
            local insert_node =
                string.format('i(%s, "%s"),', node_count, node_text)
            table.insert(insert_nodes, insert_node)
            node_count = node_count + 1
        end

        local args = {
            trigger = trigger,
            body = body_text,
            nodes = table.concat(insert_nodes, "\n"),
        }

        local result = fmt(placeholder, args, { replace_curly_braces = true })
        result = result.gsub(result, left_special_delimiter, "{")
        result = result.gsub(result, right_special_delimiter, "}")

        return result
    end

return M
