local lib_strings = require "snippet-factory.lib.strings"

describe("module.if_string_empty()", function()
    it("check if string 'empty'", function()
        assert.is_true(lib_strings.if_string_empty "")
        assert.is_true(lib_strings.if_string_empty "    ")
        assert.is_true(lib_strings.if_string_empty "        ")
        assert.is_true(lib_strings.if_string_empty "  \n  \t   ")
    end)

    it("check if string 'not empty'", function()
        assert.is_false(lib_strings.if_string_empty "ching cheng han ji")
        assert.is_false(lib_strings.if_string_empty "  tom cat")
        assert.is_false(lib_strings.if_string_empty "  jerry        ")
    end)
end)

describe("module.reduce_indent()", function()
    it("works with same level of indentation", function()
        local input = [[
    Hello
    Venus]]

        local want = [[
Hello
Venus]]

        local got = lib_strings.reduce_indent(input)

        assert.equals(want, got)
    end)

    it("works with different level of indentation", function()
        local input = [[
    Hello
        Venus]]

        local want = [[
Hello
    Venus]]

        local got = lib_strings.reduce_indent(input)

        assert.equals(want, got)
    end)
end)
