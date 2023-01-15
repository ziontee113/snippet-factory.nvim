local prototype = require "snippet-factory.business.prototype"
local test_helpers = require "snippet-factory.lib.test_helpers"

describe("prototyping, combining functionalities together", function()
    after_each(function()
        vim.api.nvim_buf_delete(0, { force = true })
    end)

    it("gets selection text, turn it into a snippet", function()
        test_helpers.set_lines [[
local x = 100
local y = 800
]]
        vim.cmd "norm! Vj"

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

        local want = [[
cs({
    trigger = "myTrigger",
    nodes = fmt(
    [=[
local x = 100
local y = 800
]=]),
    target_table = snippets,
})
]]
        local got = prototype.create_snippet(snippet_skeleton, trigger)

        assert.same(want, got)
    end)
end)
