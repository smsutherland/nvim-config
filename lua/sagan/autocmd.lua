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

autocmd({ "BufRead", "BufNewFile" }, {
    desc = "set settings for spelling",
    pattern = { "*.tex", "*.wiki" },
    group = augroup("spelling", { clear = true }),
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    desc = "Set Vimwiki which-key binds when appropriate",
    group = augroup("vimwiki-keybinds", { clear = true }),
    callback = function(args)
        if not not require("lazy.core.config").plugins["vimwiki"]._.loaded then
            if vim.fn["vimwiki#vars#get_bufferlocal"]('wiki_nr') ~= -1 then
                local wk = require("which-key")
                local buf = args.buf

                vim.opt_local.wrap = true;
                vim.opt_local.linebreak = true;

                wk.register({
                    w = {
                        h = {
                            vim.cmd.Vimwiki2HTML,
                            "Convert current page to HTML",
                            h = { vim.cmd.Vimwiki2HTMLBrowse, "Convert current page to HTML and open" },
                            a = { vim.cmd.VimwikiAll2HTML, "Convert all pages to HTML" },
                        },
                        ["<leader>"] = {
                            i = { vim.cmd.VimwikiDiaryGenerateLinks, "Generate diary links" },
                        },
                        c = { vim.cmd.VimwikiColorize, "Colorize line" },
                        n = { vim.cmd.VimwikiGoto, "Goto or create new wiki page" },
                        d = { vim.cmd.VimwikiDeleteFile, "Delete wiki page you are in" },
                        r = { vim.cmd.VimwikiRenameFile, "Rename wiki page you are in" },
                    }
                }, { mode = "n", prefix = "<leader>", buffer = buf })

                wk.register({
                    c = { vim.cmd.VimwikiColorize, "Colorize selection" },
                }, { mode = "v", prefix = "<leader>", buffer = buf })
            end
        end
    end,
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

local bufferline_group = augroup("bufferline", { clear = true })
autocmd({ "BufAdd", "BufEnter", "TabNewEntered" }, {
    desc = "Update buffers when adding new buffers",
    group = bufferline_group,
    callback = function(args)
        local buf_utils = require("sagan.util.buffer")
        if not vim.t.bufs then vim.t.bufs = {} end
        if not buf_utils.is_valid(args.buf) then return end
        if args.buf ~= buf_utils.current_buf then
            buf_utils.last_buf = buf_utils.is_valid(buf_utils.current_buf) and buf_utils.current_buf or nil
            buf_utils.current_buf = args.buf
        end
        local bufs = vim.t.bufs
        if not vim.tbl_contains(bufs, args.buf) then
            table.insert(bufs, args.buf)
            vim.t.bufs = bufs
        end
        vim.t.bufs = vim.tbl_filter(buf_utils.is_valid, vim.t.bufs)
        vim.api.nvim_exec_autocmds("User", { pattern = "BufsUpdated", modeline = false })
    end,
})

autocmd("BufDelete", {
    desc = "Update buffers when deleting buffers",
    group = bufferline_group,
    callback = function(args)
        local removed
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            local bufs = vim.t[tab].bufs
            if bufs then
                for i, bufnr in ipairs(bufs) do
                    if bufnr == args.buf then
                        removed = true
                        table.remove(bufs, i)
                        vim.t[tab].bufs = bufs
                        break
                    end
                end
            end
        end
        vim.t.bufs = vim.tbl_filter(require("sagan.util.buffer").is_valid, vim.t.bufs)
        if removed then
            vim.api.nvim_exec_autocmds("User", { pattern = "BufsUpdated", modeline = false })
        end
        vim.cmd.redrawtabline()
    end,
})
