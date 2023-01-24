local prototype = require "snippet-factory.business.prototype"
local test_helpers = require "snippet-factory.lib.test_helpers"

describe("prototyping, combining functionalities together", function()
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
]=]),
    target_table = snippets,
}})
]]
    local trigger = "myTrigger"

    it("gets selection text, turn it into a snippet", function()
        -- setup environment
        test_helpers.set_lines [[
vim.keymap.set("n", "my_mapping", function()
    -- TODO: 
end, {})
]]
        vim.cmd "norm! Vjj"

        -- define want and got, then assert
        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
    [=[
vim.keymap.set("n", "my_mapping", function()
    -- TODO: 
end, {{}})
]=]),
    target_table = snippets,
})
]]
        local got = prototype.__create_snippet_intergration_testing(
            snippet_skeleton,
            trigger
        )

        assert.same(want, got)
    end)

    it("gets selection text, dedent it, then turn it into a snippet", function()
        -- setup environment
        test_helpers.set_lines [[
        vim.keymap.set("n", "my_mapping", function()
            -- TODO: 
        end, {})
]]
        vim.cmd "norm! Vjj"

        -- define want and got, then assert
        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
    [=[
vim.keymap.set("n", "my_mapping", function()
    -- TODO: 
end, {{}})
]=]),
    target_table = snippets,
})
]]
        local got = prototype.__create_snippet_intergration_testing(
            snippet_skeleton,
            trigger
        )

        assert.same(want, got)
    end)
end)
