local selection = require "snippet-factory.lib.selection"

local highlight_groups = {
    "GruvBoxAquaBold",
    "GruvBoxOrangeBold",
    "GruvBoxGreenBold",
    "GruvBoxPurpleBold",
    "GruvBoxYellowBold",
}
local highlight_index = 1
local ns = vim.api.nvim_create_namespace "highlight_selection"

local highlight_selection = function(hl_group)
    local start_row, start_col, end_row, end_col = selection.get_visual_range()

    vim.highlight.range(
        0,
        ns,
        hl_group,
        { start_row - 1, start_col - 1 },
        { end_row - 1, end_col },
        { priority = 1000 }
    )
end

local highlight_selection_with_next_hl_group = function()
    if highlight_index > #highlight_groups then highlight_index = 1 end

    local hl_group = highlight_groups[highlight_index]
    highlight_selection(hl_group)

    highlight_index = highlight_index + 1
end

local clear_namespace = function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    highlight_index = 1
end

vim.keymap.set("n", "cns", function()
    clear_namespace()
end, {})

vim.keymap.set("x", "gj", function()
    highlight_selection_with_next_hl_group()
    vim.api.nvim_input "<Esc>"
end, {})

-- TODO: implement dot-repeat

return {
    highlight_selection = highlight_selection,
}

-- {{{nvim-execute-on-save}}}
