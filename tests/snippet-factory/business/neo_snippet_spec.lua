describe("snippet class", function()
    it("can create snippet", function()
        local session

        test_helpers.set_lines [[
Hello World.
Wassup Beijing.]]

        session = snippet_creation_session:new()

        --------------------------------------------

        vim.cmd "norm! ve"

        local got = snippet:body()

        local want = [[
{} World
Wassup Beijing.
]]

        assert.same(want, got)

        --------------------------------------------

        vim.cmd "norm! j0ee"

        local got = snippet:body()

        local want = [[
{} World
{}.
]]

        assert.same(want, got)

        -- TODO:
        -- 1. get range
        -- 2. get text from range
        -- 3. change snippet:body()
        -- 4. add replaced text to insert node tbl
    end)
end)
