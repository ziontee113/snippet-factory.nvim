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

describe("module.split_string_to_table", function()
    it("working", function()
        assert.same(
            {
                "hello",
                "venus",
            },
            vim.split(
                [[
hello
venus]],
                "\n"
            )
        )
    end)
end)
