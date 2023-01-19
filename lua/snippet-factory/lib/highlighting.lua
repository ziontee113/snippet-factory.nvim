local ns = vim.api.nvim_create_namespace "highlight_selection"

local get_visual_range = function()
    local start_row, start_col = vim.fn.line "v", vim.fn.col "v"
    local end_row, end_col = vim.fn.line ".", vim.fn.col "."

    if vim.fn.mode() == "V" then
        start_col = 1
        end_col = vim.fn.col "$"
    end

    return start_row, start_col, end_row, end_col
end

local highlight_selection = function(hl_group)
    local start_row, start_col, end_row, end_col = get_visual_range()

    vim.highlight.range(
        0,
        ns,
        hl_group,
        { start_row - 1, start_col - 1 },
        { end_row - 1, end_col },
        { priority = 1000 }
    )
end

vim.keymap.set("n", "cns", function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end, {})

vim.keymap.set("x", "gj", function()
    highlight_selection "GruvBoxAquaBold"
end, {})

return {
    highlight_selection = highlight_selection,
}

-- {{{nvim-execute-on-save}}}
