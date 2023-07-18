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
