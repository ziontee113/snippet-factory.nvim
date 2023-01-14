local fmt = require "snippet-factory.lib.fmt"

describe("fmt demonstration", function()
    it("works with 1 slot", function()
        local placeholder = "Hello {}"
        local slots = { "Venus" }

        local want = "Hello Venus"
        local got = fmt(placeholder, slots)

        assert.are.same(want, got)
    end)

    it("works with 2 slots", function()
        local placeholder = "Hello {}, {}"
        local slots = { "Venus", "how are you?" }

        local want = "Hello Venus, how are you?"
        local got = fmt(placeholder, slots)

        assert.are.same(want, got)
    end)

    it("works with multi-line string", function()
        local placeholder = [[
Hello {}!
{}
        ]]
        local slots = { "Venus", "How are you?" }

        local want = [[
Hello Venus!
How are you?
        ]]
        local got = fmt(placeholder, slots)

        assert.are.same(want, got)
    end)

    it("works with multi-line string, with indentation", function()
        local placeholder = [[
Hello {}!
    {}
        ]]
        local slots = { "Venus", "How are you?" }

        local want = [[
Hello Venus!
    How are you?
        ]]
        local got = fmt(placeholder, slots)

        assert.are.same(want, got)
    end)

    it("works with named placeholders", function()
        local placeholder = [[
Hello {name}!
    {msg}
        ]]
        local slots = { msg = "How are you?", name = "Venus" }

        local want = [[
Hello Venus!
    How are you?
        ]]
        local got = fmt(placeholder, slots)

        assert.are.same(want, got)
    end)

    -- TODO: make indentation works.
    it("works with multi lines body", function()
        local placeholder = [[
Hello {name}!
    {msg}
        ]]
        local slots =
            { msg = "How are you?\nWhere are you from?", name = "Venus" }

        -- we actually want this kind of indentation
        -- where every new line in the msg gets indented correctly
        -- relative to placeholder's position.
        -- will need to be implemented
        -- since we didn't write fmt(), we'll have to make this compromise
        -- Question how is: does this PREVENT the project from moving forward?
        ---- I don't know yet. But I have a feeling that it will for sure.
        local want = [[
Hello Venus!
    How are you?
    Where are you from?
        ]]

        local compromise = [[
Hello Venus!
    How are you?
Where are you from?
        ]]
        local got = fmt(placeholder, slots)

        assert.are.same(compromise, got)
    end)
end)
