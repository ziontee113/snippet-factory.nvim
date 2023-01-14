local M = {}

--=============== Strings Utils ===============

---check if string is empty / consists of only whitespaces
---uses `string.match(str, "%s*")`
---@param ctr string
---@return boolean
M.if_string_empty = function(str)
    if type(str) == "table" then str = str[1] end

    if string.match(str, "%s*") == str then return true end

    return false
end

---Currently with the intention of reducing "spaces", not "tabs"
M.reduce_indent = function(input)
    local lines = vim.split(input, "\n")
    local smallest_indent = math.huge

    for _, line in ipairs(lines) do
        local og_len = #line
        local trimmed = string.gsub(line, "%s+", "")
        local trimmed_len = #trimmed
        local spaces_len = og_len - trimmed_len

        if spaces_len < smallest_indent then smallest_indent = spaces_len end
    end

    local new_lines = {}
    local pattern = "^" .. string.rep(" ", smallest_indent)
    for _, line in ipairs(lines) do
        local new_line = string.gsub(line, pattern, "")
        table.insert(new_lines, new_line)
    end

    return table.concat(new_lines, "\n")
end

return M
