local logic = require "snippet-factory.business.logic"
local test_helpers = require "snippet-factory.lib.test_helpers"

describe("combines fmt with get_text.get_selection_text", function()
    after_each(function()
        vim.api.nvim_buf_delete(0, { force = true })
    end)

    it("works with single line V selection", function()
        -- set lines in buffer
        test_helpers.set_lines [[local my_var = 100]]
        vim.cmd "norm! V"

        local want = [[local my_var = 100]]
        local got = logic.create_snippet [[{body}]]

        assert.same(want, got)
    end)
end)
