vim.g.mapleader = " "
require("sagan.set")
require("sagan.lazy")
require("sagan.autocmd")

pcall(require, "user")
