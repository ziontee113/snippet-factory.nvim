local M = {}

M.write_to_file = function(file_path, new_lines)
    local lines = vim.fn.readfile(file_path)

    local marker_start_idx = -1
    for i, line in pairs(lines) do
        if
            line
                == "-------------------------------------------------------------------------"
            and lines[i + 2] == "return snippets, autosnippets"
        then
            marker_start_idx = i - 1
            break
        end
    end

    if marker_start_idx ~= -1 then
        for i, line in ipairs(new_lines) do
            table.insert(lines, marker_start_idx + i, line)
        end

        vim.fn.writefile(lines, file_path)
    end
end

return M
