local M = {}

--=============== Strings Utils ===============

---check if string is empty / consists of only whitespaces
---uses `string.match(str, "%s*")`
---@param str string
---@return boolean
M.if_string_empty = function(str)
    if type(str) == "table" then str = str[1] end

    if string.match(str, "%s*") == str then return true end

    return false
end

---Currently with the intention of reducing `spaces`, not `tabs`
---Will annoy `tab` users if kept like this
---@param input string|table
---@return any
M.dedent = function(input)
    local lines
    if type(input) == "table" then
        lines = input
    elseif type(input) == "string" then
        lines = vim.split(input, "\n")
    end

    local smallest_indent = math.huge

    for _, line in ipairs(lines) do
        local og_len = #line
        -- local trimmed = string.gsub(line, "%s+", "")
        local trimmed = string.gsub(line, "^ +", "")
        local trimmed_len = #trimmed
        local spaces_len = og_len - trimmed_len

        if not M.if_string_empty(line) and (spaces_len < smallest_indent) then
            smallest_indent = spaces_len
        end
    end

    local new_lines = {}
    local pattern = "^" .. string.rep(" ", smallest_indent)
    for _, line in ipairs(lines) do
        local new_line = string.gsub(line, pattern, "")
        table.insert(new_lines, new_line)
    end

    if type(input) == "table" then return new_lines end
    if type(input) == "string" then return table.concat(new_lines, "\n") end
end

M.replace_range =
    ---@param input string
    ---@param replacement string
    ---@param start_row number
    ---@param start_col number
    ---@param end_row number
    ---@param end_col number
    ---@return string|table
    function(input, replacement, start_row, start_col, end_row, end_col)
        local lines
        if type(input) == "table" then
            lines = input
        elseif type(input) == "string" then
            lines = vim.split(input, "\n")
        end

        local lines_to_delete = {}
        for i, _ in ipairs(lines) do
            -- checks for lines to delete
            if i > start_row and i < end_row then
                table.insert(lines_to_delete, i)
            end

            if i == start_row and i == end_row then
                lines[i] = lines[i]:sub(1, start_col - 1)
                    .. replacement
                    .. lines[i]:sub(end_col + 1)
            else
                if i == start_row then
                    lines[i] = lines[i]:sub(1, start_col - 1) .. replacement
                end
                if i == end_row then
                    lines[i] = lines[i]:sub(end_col + 1)
                    if lines[i] == "" then table.insert(lines_to_delete, i) end
                end
            end
        end

        for _, i in ipairs(lines_to_delete) do
            table.remove(lines, i)
        end

        if type(input) == "table" then return lines end
        return table.concat(lines, "\n")
    end

return M
