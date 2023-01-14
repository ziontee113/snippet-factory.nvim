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

return M
