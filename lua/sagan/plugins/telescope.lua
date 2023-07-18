return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                layout_config = {
                    horizontal = { prompt_position = "top", preview_width = 0.55, },
                    vertical = { mirror = false, },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120,
                },
                sorting_strategy = "ascending",
                mappings = {
                    n = { q = actions.close },
                    i = {
                        ["<esc>"] = actions.close,
                        ["<C-l>"] = actions.cycle_history_next,
                        ["<C-h>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
            },
        }
    end,
}
