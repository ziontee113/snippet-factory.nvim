local test_helpers = require "snippet-factory.lib.test_helpers"
local lib_get_text = require "snippet-factory.lib.get_text"

describe("get_selection_lines tests", function()
    after_each(function()
        vim.api.nvim_buf_delete(0, { force = true })
    end)

    it("works", function()
        test_helpers.set_lines [[
Hello World.
Wassup Beijing.]]

        vim.cmd "norm! wvje"

        local want = {
            "World.",
            "Wassup Beijing",
        }
        local got = lib_get_text.get_selection_lines()

        assert.same(want, got)
    end)

    it("get_selection_text works", function()
        test_helpers.set_lines [[
Hello World.
Wassup Beijing.]]

        vim.cmd "norm! wvje"

        local want = [[
World.
Wassup Beijing]]
        local got = lib_get_text.get_selection_text()

        assert.same(want, got)
    end)
end)
