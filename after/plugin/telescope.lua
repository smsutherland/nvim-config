local builtin = require("telescope.builtin")
local wk = require("which-key")

wk.register({
    f = {
        name = "Files",
        f = { builtin.find_files, "File Telescope" },
        g = { builtin.git_files, "Git File Telescope" },
    },
}, { mode = "n", prefix = "<leader>" })
