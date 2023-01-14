local M = {}

--=============== Strings Utils ===============

---check if string is empty / consists of only whitespaces
---uses `string.match(str, "%s*")`
---@param str string
---@return boolean
function M.if_string_empty(str)
    if type(str) == "table" then str = str[1] end

    if string.match(str, "%s*") == str then return true end

    return false
end

--[copied from stackoverflow](https://stackoverflow.com/a/40180465/19205063)
---@param str string
---@param sep string|nil
---@param keep_last_empty_line boolean|nil
---@return table
function M.split_string_to_table(str, sep, keep_last_empty_line)
    local fields = {}

    sep = sep or "\n"
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(str, pattern, function(c)
        fields[#fields + 1] = c --< wtf does this c mean?
    end)

    if not keep_last_empty_line then
        local last_line = fields[#fields]
        if M.if_string_empty(last_line) then table.remove(fields, #fields) end
    end

    return fields
end

return M
