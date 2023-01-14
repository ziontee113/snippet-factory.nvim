local M = {}

M.get_selection_text = function()
    local start_row, start_col = vim.fn.line "v", vim.fn.col "v"
    local end_row, end_col = vim.fn.line ".", vim.fn.col "."

    if
        start_row > end_row or (start_row == end_row and start_col >= end_col)
    then
        start_row, start_col = vim.fn.line ".", vim.fn.col "."
        end_row, end_col = vim.fn.line "v", vim.fn.col "v"
    end

    local text
    if vim.fn.mode() == "v" then
        text = vim.api.nvim_buf_get_text(
            0,
            start_row - 1,
            start_col - 1,
            end_row - 1,
            end_col,
            {}
        )
    elseif vim.fn.mode() == "V" then
        text = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    end

    return text
end

return M
