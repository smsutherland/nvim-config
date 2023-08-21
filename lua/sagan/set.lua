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
vim.opt.laststatus = 3
vim.opt.showcmdloc = "statusline"
vim.opt.clipboard = "unnamedplus"

vim.g.icons = "nerd"
vim.g.git_worktrees = nil

vim.t.bufs = vim.t.bufs or vim.api.nvim_list_bufs()

vim.filetype.add({
    extension = {
        wiki = "wiki",
    }
})
vim.g.vimwiki_list = {
    { path = "~/vimwiki" },
    {
        path = "~/student/text/",
        name = "School Notes",
        template_path = "~/student/templates/",
        template_default = "main",
        template_ext = ".html",
        path_html = "~/student/html/",
        auto_export = 1,
        auto_toc = 1,
    }
}
