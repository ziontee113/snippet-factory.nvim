local logic = require "snippet-factory.business.logic"
local test_helpers = require "snippet-factory.lib.test_helpers"

local works = function(msg, body, norm_cmd, want)
    it("works: " .. msg, function()
        local cmd = "norm! " .. norm_cmd
        vim.cmd(cmd)
        local got = logic.create_snippet(body)

        assert.are.same(want, got)
    end)
end

describe("combines lib.fmt with lib.get_text.get_selection_text", function()
    before_each(function()
        test_helpers.set_lines [[
local my_var = 100
local lib = require("lib.module")]]
    end)

    after_each(function()
        vim.api.nvim_buf_delete(0, { force = true })
    end)

    works(
        "placeholder only, single line V selection",
        [[{body}]],
        "V",
        [[local my_var = 100]]
    )

    works(
        "placeholder only, multiple lines V selection",
        [[{body}]],
        "Vj",
        [[
local my_var = 100
local lib = require("lib.module")]]
    )

    works(
        "placeholder only, part of single line v selection",
        [[{body}]],
        "vee",
        [[local my_var]]
    )

    works(
        "placeholder only, part of 2 lines v selection",
        [[{body}]],
        "vjee",
        [[
local my_var = 100
local lib]]
    )
end)
