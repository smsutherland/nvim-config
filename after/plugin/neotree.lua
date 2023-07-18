local wk = require("which-key")

wk.register({ e = { function() vim.cmd.Neotree("toggle") end, "Toggle Neotree" } }, { mode = "n", prefix = "<leader>" })
