local ip = require "snippet-factory.business.identifier_replace_prototype"
local test_helpers = require "snippet-factory.lib.test_helpers"

describe("identifier_replace_prototype", function()
    after_each(function()
        vim.api.nvim_buf_delete(0, { force = true })
    end)

    -- define skeleton and trigger
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
    local trigger = "myTrigger"

    it("works with single-line node replacement", function()
        -- setup environment
        test_helpers.set_lines [[
local name = function()
    local x = 100    
end
]]
        vim.cmd "norm! Vjj"

        -- define custom tree-sitter query
        local query = [[
    ;; query
    ((identifier) @cap)
]]

        -- define want and got, then assert
        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
        [=[
local {} = function()
    local {} = 100    
end
]=],
        {
            i(1, "name"),
            i(2, "x"),
        }
),
    target_table = snippets,
})
]]
        local got = ip.create_snippet_with_identifiers_replaced(
            snippet_skeleton,
            trigger,
            query
        )

        assert.same(want, got)
    end)

    it("works with multi-line node replacement", function()
        -- setup environment
        test_helpers.set_lines [[
local name = function()
    local x = 100    
end
]]
        vim.cmd "norm! Vjj"

        -- define custom tree-sitter query
        local query = [[
    ;; query
    ((function_definition) @cap)
]]

        -- define want and got, then assert
        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
        [=[
local name = {}
]=],
        {
            i(1, ""),
        }
),
    target_table = snippets,
})
]]
        local got = ip.create_snippet_with_identifiers_replaced(
            snippet_skeleton,
            trigger,
            query
        )

        assert.same(want, got)
    end)

    it("works with multiple single-line node replacements", function()
        -- setup environment
        test_helpers.set_lines [[
local first_var, second_var = 10, 20
]]
        vim.cmd "norm! V"

        -- define custom tree-sitter query
        local query = [[
        ;; query
        ((identifier) @cap)
    ]]

        -- define want and got, then assert
        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
        [=[
local {}, {} = 10, 20
]=],
        {
            i(1, "first_var"),
            i(2, "second_var"),
        }
),
    target_table = snippets,
})
]]
        local got = ip.create_snippet_with_identifiers_replaced(
            snippet_skeleton,
            trigger,
            query
        )

        assert.same(want, got)
    end)

    it("works with multiple multi-line node replacements", function()
        -- setup environment
        test_helpers.set_lines [[
local number = function()
    local x = 100
end
local name = function()
    local x = 100
end]]
        vim.cmd "norm! VG"

        -- define custom tree-sitter query
        local query = [[
        ;; query
        ((function_definition) @cap)
    ]]

        -- define want and got, then assert
        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
        [=[
local number = {}
local name = {}
]=],
        {
            i(1, ""),
            i(2, ""),
        }
),
    target_table = snippets,
})
]]
        local got = ip.create_snippet_with_identifiers_replaced(
            snippet_skeleton,
            trigger,
            query
        )

        assert.same(want, got)
    end)

    it("works when there's () and [] involved", function()
        -- setup environment
        test_helpers.set_lines [[
local tsnode, other_var = matches[1], 100
local tsnode, other_var = matches[1], 100
]]
        vim.cmd "norm! Vj"

        -- define custom tree-sitter query
        local query = [[
        ;; query
        ((identifier) @cap)
    ]]

        -- define want and got, then assert
        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
        [=[
local {}, {} = {}[1], 100
local {}, {} = {}[1], 100
]=],
        {
            i(1, "tsnode"),
            i(2, "other_var"),
            i(3, "matches"),
            i(4, "tsnode"),
            i(5, "other_var"),
            i(6, "matches"),
        }
),
    target_table = snippets,
})
]]
        local got = ip.create_snippet_with_identifiers_replaced(
            snippet_skeleton,
            trigger,
            query
        )

        assert.same(want, got)
    end)

    it(
        "works with multiple multi-line node replacements, with . in them",
        function()
            -- setup environment
            test_helpers.set_lines [[
local tsnode = matches[1]
local node_text = vim.treesitter.get_node_text(tsnode, og_body_text)
local start_row, start_col, end_row, end_col = tsnode:range()
]]
            vim.cmd "norm! Vjj"

            -- define custom tree-sitter query
            local query = [[
        ;; query
        ((identifier) @cap)
    ]]

            -- define want and got, then assert
            local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
        [=[
local {} = {}[1]
local {} = {}.{}.{}({}, {})
local {}, {}, {}, {} = {}:{}()
]=],
        {
            i(1, "tsnode"),
            i(2, "matches"),
            i(3, "node_text"),
            i(4, "vim"),
            i(5, "treesitter"),
            i(6, "get_node_text"),
            i(7, "tsnode"),
            i(8, "og_body_text"),
            i(9, "start_row"),
            i(10, "start_col"),
            i(11, "end_row"),
            i(12, "end_col"),
            i(13, "tsnode"),
            i(14, "range"),
        }
),
    target_table = snippets,
})
]]
            local got = ip.create_snippet_with_identifiers_replaced(
                snippet_skeleton,
                trigger,
                query
            )

            assert.same(want, got)
        end
    )
end)
