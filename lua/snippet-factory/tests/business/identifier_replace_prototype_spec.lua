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
end)
