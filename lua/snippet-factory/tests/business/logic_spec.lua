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

describe(
    "combines fmt() with get_selection_text(), placeholder only",
    function()
        before_each(function()
            test_helpers.set_lines [[
local my_var = 100
local lib = require("lib.module")]]
        end)

        after_each(function()
            vim.api.nvim_buf_delete(0, { force = true })
        end)

        works(
            "single line V selection",
            [[{body}]],
            "V",
            [[local my_var = 100]]
        )

        works(
            "multiple lines V selection",
            [[{body}]],
            "Vj",
            [[
local my_var = 100
local lib = require("lib.module")]]
        )

        works(
            "part of single line v selection",
            [[{body}]],
            "vee",
            [[local my_var]]
        )

        works(
            "part of 2 lines v selection",
            [[{body}]],
            "vjee",
            [[
local my_var = 100
local lib]]
        )
    end
)

describe(
    "combines fmt() with get_selection_text(), placeholder with surrounding contents",
    function()
        before_each(function()
            test_helpers.set_lines [[
local my_var = 100
local lib = require("lib.module")]]
        end)

        after_each(function()
            vim.api.nvim_buf_delete(0, { force = true })
        end)

        works(
            "single line V selection",
            [[
local function my_func()
    {body}
end
]],
            "V",
            [[
local function my_func()
    local my_var = 100
end
]]
        )

        works(
            "2 lines V selection",
            [[
local function my_func()
    {body}
end
]],
            "Vj",
            [[
local function my_func()
    local my_var = 100
local lib = require("lib.module")
end
]]
        )
    end
)
