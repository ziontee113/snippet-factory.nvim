local M = {}

--------------------------------------------

local lib_get_text = require "lua.snippet-factory.lib.get_text"

local SnippetSession = {
    -- TODO: init default opts here
}
SnippetSession.__index = SnippetSession

function SnippetSession:new(opts)
    local session = setmetatable({}, SnippetSession)

    -- TODO: do something with opts

    return session
end

function SnippetSession:add_placeholder()
    self.body = lib_get_text.get_selection_text({ dedent = true })
end

--------------------------------------------

return M
