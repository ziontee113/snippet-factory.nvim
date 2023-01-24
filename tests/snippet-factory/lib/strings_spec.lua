local lib_strings = require "snippet-factory.lib.strings"

describe("module.if_string_empty()", function()
    it("check if string `empty`", function()
        assert.is_true(lib_strings.if_string_empty "")
        assert.is_true(lib_strings.if_string_empty "    ")
        assert.is_true(lib_strings.if_string_empty "        ")
        assert.is_true(lib_strings.if_string_empty "  \n  \t   ")
    end)

    it("check if string `not empty`", function()
        assert.is_false(lib_strings.if_string_empty "ching cheng han ji")
        assert.is_false(lib_strings.if_string_empty "  tom cat")
        assert.is_false(lib_strings.if_string_empty "  jerry        ")
    end)
end)

describe("module.reduce_indent()", function()
    it("works with single line, case 1", function()
        local input = [[
    Hello]]

        local want = [[
Hello]]

        local got = lib_strings.dedent(input)

        assert.equals(want, got)
    end)

    it("works with single line, case 2", function()
        local input = [[
    Hello
]]

        local want = [[
Hello
]]

        local got = lib_strings.dedent(input)

        assert.equals(want, got)
    end)

    it("works with same level of indentation", function()
        local input = [[
    Hello
    Venus]]

        local want = [[
Hello
Venus]]

        local got = lib_strings.dedent(input)

        assert.equals(want, got)
    end)

    it("works with 2 different levels of indentation", function()
        local input = [[
    Hello
        Venus]]

        local want = [[
Hello
    Venus]]

        local got = lib_strings.dedent(input)

        assert.same(want, got)
    end)

    it("works with 3 different levels of indentation", function()
        local input = [[
    Hello
            Something More
        Venus]]

        local want = [[
Hello
        Something More
    Venus]]

        local got = lib_strings.dedent(input)

        assert.same(want, got)
    end)

    it("works if input is type table", function()
        local input = { "    -- TODO:" }
        local want = { "-- TODO:" }

        local got = lib_strings.dedent(input)
        assert.same(want, got)
    end)
end)

describe("replace_range", function()
    it("works with single line case", function()
        local input = "hello venus"
        local want = "welcome venus"

        local got = lib_strings.replace_range(input, "welcome", 1, 1, 1, 5)
        assert.same(want, got)
    end)

    it("works with multi line, range at same line", function()
        local input = [[
local name = function()
    local x = 10
end
]]
        local want = [[
local {} = function()
    local x = 10
end
]]

        local got = lib_strings.replace_range(input, "{}", 1, 7, 1, 10)
        assert.same(want, got)
    end)

    it("works with multi line, range at different lines", function()
        local input = [[
local name = function()
    local x = 10
end]]
        local want = [[
local name = {}]]

        local got = lib_strings.replace_range(input, "{}", 1, 14, 3, 3)
        assert.are.same(want, got)
    end)
end)
