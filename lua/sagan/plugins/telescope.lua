local get_icon = require("sagan.icons").get_icon

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                git_wroktrees = vim.g.git_worktrees,
                prompt_prefix = get_icon("Selected"),
                selection_caret = get_icon("Selected"),
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
    init = function()
        local builtin = require("telescope.builtin")
        local wk = require("which-key")

        wk.register({
            f = {
                name = "Files",
                f = { builtin.find_files, "File Telescope" },
                g = { builtin.git_files, "Git File Telescope" },
                b = { builtin.buffers, "Find Buffers" },
                w = { builtin.live_grep, "Find Words" },
                W = { function()
                    builtin.live_grep({
                        additional_args = function(args)
                            return vim.list_extend(args, { "--hidden", "--no-ignore" })
                        end
                    })
                end, "Find Words in All Files" }
            },
        }, { mode = "n", prefix = "<leader>" })
    end
}
