local lib_get_text = require "snippet-factory.lib.get_text"
local lib_strings = require "snippet-factory.lib.strings"
local fmt = require "snippet-factory.lib.fmt"

local M = {}

M.create_snippet_with_identifiers_replaced =
    function(placeholder, trigger, query, body_text)
        -- specify special delimiters
        local left_special_delimiter = "𓊆"
        local right_special_delimiter = "𓊇"

        -- get body text
        body_text = body_text
            or lib_get_text.get_selection_text({ dedent = true })
        local insert_nodes = {}
        local og_body_text = vim.deepcopy(body_text)

        -- Treesitter magic
        local lang = "lua"

        local lang_tree = vim.treesitter.get_string_parser(
            body_text,
            lang,
            { injections = { [lang] = "" } }
        )
        local root = lang_tree:parse()[1]:root()

        -- initialize offset
        local x_offset, y_offset = 0, 0
        local x_line = 0

        local node_count = 1 -- keep track of node index
        local iter_query = vim.treesitter.query.parse_query(lang, query)
        for _, matches, _ in iter_query:iter_matches(root) do
            local tsnode = matches[1]
            local node_text = vim.treesitter.get_node_text(tsnode, og_body_text)
            local start_row, start_col, end_row, end_col = tsnode:range()

            -- handle x_offset
            if start_row ~= x_line then
                x_line = start_row
                x_offset = 0
            end

            -- handle start_col_mod
            local start_col_mod = start_col + 1
            local end_col_mod = end_col

            if x_line == start_row then
                start_col_mod = start_col_mod + x_offset
                end_col_mod = end_col_mod + x_offset
            end

            ---@diagnostic disable-next-line: cast-local-type
            body_text = lib_strings.replace_range(
                body_text,
                left_special_delimiter .. right_special_delimiter,
                start_row + y_offset + 1,
                start_col_mod,
                end_row + y_offset + 1,
                end_col_mod
            )

            -- offset processing
            y_offset = y_offset - (end_row - start_row)
            -- handle x_offset, again!!
            -- sequencing is all over the place, please refactor this!
            if x_line == start_row then
                x_offset = x_offset
                    - (end_col - start_col)
                    + (#left_special_delimiter + #right_special_delimiter)
            end

            if string.find(node_text, "\n") then node_text = "" end
            local insert_node =
                string.format('i(%s, "%s"),', node_count, node_text)
            insert_node = insert_node:gsub("%\\", "\\\\") -- escape \
            table.insert(insert_nodes, insert_node)
            node_count = node_count + 1
        end

        local args = {
            trigger = trigger,
            body = body_text,
            nodes = table.concat(insert_nodes, "\n"),
        }

        -- get result and replace special delimiters
        local result = fmt(placeholder, args, { replace_curly_braces = true })
        result = result.gsub(result, vim.pesc(left_special_delimiter), "{")
        result = result.gsub(result, vim.pesc(right_special_delimiter), "}")

        return result
    end

local filesystem = require "snippet-factory.lib.filesystem"

M.input_trigger_then_create_snippet = function()
    local snippet_skeleton = [[
cs({{
    trigger = "{trigger}",
    nodes = fmt(
        [=[
{body}
]=],
        {{
            {nodes}
        }}
),
    target_table = snippets,
}})
]]
    local query = [[
    ;; query
    ((identifier) @cap)
    ("string_content" @cap)
]]

    local body_text = lib_get_text.get_selection_text({ dedent = true })

    vim.ui.input(
        { prompt = "Please enter Trigger for this Snippet" },
        function(trigger)
            local snippet_content = M.create_snippet_with_identifiers_replaced(
                snippet_skeleton,
                trigger,
                query,
                body_text
            )

            local file_path =
                "/home/ziontee113/.config/nvim/snippets/lua/extra.lua"

            filesystem.write_to_file(
                file_path,
                vim.split(snippet_content, "\n")
            )

            require("luasnip.loaders").reload_file(vim.fn.expand(file_path))
        end

        -- TODO: have TS node picker (kinda like TSP or Query Secretary) for customizing picking nodes
    )
end

vim.keymap.set("x", "<leader>sc", function()
    M.input_trigger_then_create_snippet()
end, {})

return M
-- {{{nvim-execute-on-save}}}
