local get_visual_range = function()
    local start_row, start_col = vim.fn.line "v", vim.fn.col "v"
    local end_row, end_col = vim.fn.line ".", vim.fn.col "."

    if vim.fn.mode() == "V" then
        start_col = 1
        end_col = vim.fn.col "$"
    end

    return start_row, start_col, end_row, end_col
end

return {
    get_visual_range = get_visual_range,
}
