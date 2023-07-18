vim.g.mapleader = " "

local wk = require("which-key")

wk.register({
    J = { ":m '>+1<CR>gv=gv", "Move selection down" },
    K = { ":m '<-2<CR>gv=gv", "Move selection up" },
}, { mode = "v" })
