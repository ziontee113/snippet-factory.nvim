---@diagnostic disable: redefined-local

local test_helpers = require "snippet-factory.lib.test_helpers"
local SnippetSession =
    require("snippet-factory.new_thang.session").SnippetSession

describe("snippet class", function()
    it("can create snippet", function()
        test_helpers.set_lines [[
Hello World.
Wassup Beijing.]]

        vim.cmd "norm! VG"
        local session = SnippetSession:new()
        vim.cmd "norm! gg"

        local got = session:get_body()
        local want = [[
Hello World.
Wassup Beijing.]]
        assert.same(want, got)

        --------------------------------------------

        vim.cmd "norm! ve"
        session:add_placeholder()

        local got = session:get_body()
        local want = [[
{} World
Wassup Beijing.
        ]]
        assert.same(want, got)

        --         --------------------------------------------
        --
        --         vim.cmd "norm! j0ee"
        --         session:add_placeholder()
        --
        --         local got = session:get_body()
        --         local want = [[
        -- {} World
        -- {}.
        -- ]]
        --         assert.same(want, got)
        --
        --         -- TODO:
        --         -- 1. get range
        --         -- 2. get text from range
        --         -- 3. change snippet:body()
        --         -- 4. add replaced text to insert node tbl
    end)
end)
