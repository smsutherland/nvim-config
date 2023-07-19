vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false

vim.opt.smartindent = true
vim.opt.smartcase = true

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.virtualedit = "block"

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.showtabline = 2
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
vim.opt.cmdheight = 0
vim.opt.fillchars = { eob = " " }

vim.g.icons = "nerd"
vim.g.git_worktrees = nil
