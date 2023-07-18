local set_key = require("sagan.util").set_which_key
local wk = require("which-key")

wk.register({
    g = {
        name = "git",
        g = { vim.cmd.LazyGit, "Open LazyGit" }
    },
}, { mode = "n", prefix = "<leader>" })
