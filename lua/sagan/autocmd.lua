local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local util = require("sagan.util")

autocmd("BufEnter", {
    desc = "Open Neo-Tree on startup with directory",
    group = augroup("neotree_start", { clear = true }),
    callback = function()
        if package.loaded["neo-tree"] then
            vim.api.nvim_del_augroup_by_name("neotree_start")
        else
            local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
            if stats and stats.type == "directory" then
                vim.api.nvim_del_augroup_by_name("neotree_start")
                require("neo-tree")
            end
        end
    end
})

local nt_git = augroup("neotree_git_refresh", { clear = true })
autocmd("BufWritePost", {
    pattern = "*",
    desc = "Refresh Neo-Tree git when saving a buffer",
    group = nt_git,
    callback = function()
        if package.loaded["neo-tree.sources.git_status"] then require("neo-tree.sources.git_status").refresh() end
    end
})

autocmd("TermClose", {
    pattern = "*lazygit",
    desc = "Refresh Neo-Tree git when closing lazygit",
    group = nt_git,
    callback = function()
        if package.loaded["neo-tree.sources.git_status"] then require("neo-tree.sources.git_status").refresh() end
    end
})

local rel_num_ctrl = augroup("relative number control", { clear = true })
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
    group = augroup("highlightyank", { clear = true }),
    pattern = "*",
    callback = function() vim.highlight.on_yank() end,
})

autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
    desc = "File detection",
    group = augroup("file_user_events", { clear = true }),
    callback = function(args)
        if not (vim.fn.expand("%") == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
            vim.schedule(function()
                vim.api.nvim_exec_autocmds("User", { pattern = "File", modeline = false })
            end)
            if
                require("sagan.util.git").file_worktree()
                or util.cmd({ "git", "-C", vim.fn.expand("%:p:h"), "rev-parse" }, false)
            then
                vim.schedule(function()
                    vim.api.nvim_exec_autocmds("User", { pattern = "GitFile", modeline = false })
                end)
                vim.api.nvim_del_augroup_by_name("file_user_events")
            end
        end
    end
})
