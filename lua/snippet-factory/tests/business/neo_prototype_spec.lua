local neo_prototype = require "snippet-factory.business.neo_prototype"
local test_helpers = require "snippet-factory.lib.test_helpers"

describe("neo prototype", function()
    it("works", function()
        test_helpers.set_lines [[
Hello World.
Wassup Beijing.]]

        local snippet = neo_prototype.create_new_snippet()

        vim.cmd "norm! vw"

        snippet:add_placeholder()

        local want = [[
{} World
Wassup Beijing.
]]

        local got = snippet:placeholder()

        assert.same(want, got)
    end)
end)

-- how about we pick up user's selection on ModeChanged autocmd?
