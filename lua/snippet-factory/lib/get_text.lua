local M = {}

M.get_selection_text = function()
    local start_row, start_col = vim.fn.line "v", vim.fn.col "v"
    local end_row, end_col = vim.fn.line ".", vim.fn.col "."

    local text = vim.api.nvim_buf_get_text(
        0,
        start_row - 1,
        start_col - 1,
        end_row - 1,
        end_col,
        {}
    )

    return text
end

return M
