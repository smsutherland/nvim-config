local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TermClose", {
    pattern = "*lazygit",
    desc = "Refresh Neo-Tree git when closing lazygit",
    group = augroup("neotree_git_refresh", {clear = true}),
    callback = function()
        if package.loaded["neo-tree.sources.git_status"] then require("neo-tree.sources.git_status").refresh() end
    end
})

local rel_num_ctrl = augroup("relative number control", {clear = true})
autocmd("InsertEnter", {
    pattern = "*",
    desc = "Turn off relative numbers in insert mode",
    group = rel_num_ctrl,
    callback = function()
        vim.opt.relativenumber = false
    end
})

autocmd("InsertLeave", {
    pattern = "*",
    desc = "Turn on relative numbers leaving insert mode",
    group = rel_num_ctrl,
    callback = function()
        vim.opt.relativenumber = true
    end
})

autocmd("TextYankPost", {
    desc = "Highlight yanked text",
    group = augroup("highlightyank", {clear = true}),
    pattern = "*",
    callback = vim.highlight.on_yank
})
