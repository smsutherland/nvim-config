local function make_tabline()
    local utils = require("heirline.utils")
    local get_icon = require("sagan.icons").get_icon

    local TablineFileName = {
        provider = function(self)
            local filename = self.filename
            filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
            return filename
        end,
        hl = function(self)
            return { bold = self.is_active or self.is_visible, italic = true }
        end,
    }

    local TablineFileFlags = {
        {
            condition = function(self)
                return vim.api.nvim_buf_get_option(self.bufnr, "modified")
            end,
            provider = " " .. get_icon("FileModified"),
            hl = { fg = "green" },
        },
        {
            condition = function(self)
                return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                    or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
            end,
            provider = function(self)
                if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
                    return get_icon("Terminal")
                else
                    return get_icon("FileReadOnly")
                end
            end,
        },
    }

    local FileIcon = {
        init = function(self)
            local filename = self.filename
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
                { default = true })
        end,
        provider = function(self)
            return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end
    }

    local TablineFileNameBlock = {
        init = function(self)
            self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,
        hl = function(self)
            if self.is_active then
                return "TabLineSel"
            else
                return "TabLine"
            end
        end,
        on_click = {
            callback = function(_, minwid, _, button)
                if (button == "m") then -- close on mouse middle click
                    vim.schedule(function()
                        vim.api.nvim_buf_delete(minwid, { force = false })
                    end)
                else
                    vim.api.nvim_win_set_buf(0, minwid)
                end
            end,
            minwid = function(self)
                return self.bufnr
            end,
            name = "heirline_tabline_buffer_callback",
        },
        FileIcon,
        TablineFileName,
        TablineFileFlags,
    }

    local TablineCloseButton = {
        condition = function(self)
            return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
        end,
        { provider = " " },
        {
            provider = get_icon("BufferClose"),
            hl = { fg = "gray" },
            on_click = {
                callback = function(_, minwid)
                    vim.schedule(function()
                        vim.api.nvim_buf_delete(minwid, { force = false })
                        vim.cmd.redrawtabline()
                    end)
                end,
                minwid = function(self)
                    return self.bufnr
                end,
                name = "heirline_tabline_close_buffer_callback",
            },
        },
    }

    local TablineBufferBlock = utils.surround({ "", "" },
        function(self)
            if self.is_active then
                return utils.get_highlight("TabLineSel").bg
            else
                return utils.get_highlight("TabLine").bg
            end
        end,
        { TablineFileNameBlock, TablineCloseButton })

    local BufferLine = utils.make_buflist(
        TablineBufferBlock,
        { provider = "", hl = { fg = "gray" } },
        { provider = "", hl = { fg = "gray" } },
        function() return vim.t.bufs end,
        -- nil,
        false
    )

    return {
        { -- file tree padding
            condition = function(self)
                local filetypes = { "neo%-tree", "undotree" }
                local wins = vim.api.nvim_tabpage_list_wins(0)
                self.winids = {}
                local result = false
                for _, winid in ipairs(wins) do
                    for _, filetype in ipairs(filetypes) do
                        if vim.bo[vim.api.nvim_win_get_buf(winid)].filetype:find(filetype) then
                            result = true
                            self.winids[#self.winids + 1] = winid
                        end
                    end
                end
                return result
            end,
            provider = function(self)
                local length = 0
                for _, winid in ipairs(self.winids) do
                    length = length + vim.api.nvim_win_get_width(winid)
                end
                return string.rep(" ", length + 1)
            end,
            hl = { bg = utils.get_highlight("Normal").bg },
        },
        BufferLine,
        {
            provider = "%=",
            hl = { bg = utils.get_highlight("Normal").bg },
        },
    }
end

local function make_statusline()
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")
    local get_icon = require("sagan.icons").get_icon

    local ViMode = {
        init = function(self)
            self.mode = vim.fn.mode(1)
        end,
        static = {
            mode_names = {
                n = "--NOR--",
                no = "N?",
                nov = "N?",
                noV = "N?",
                ["no\22"] = "N?",
                niI = "Ni",
                niR = "Nr",
                niV = "Nv",
                nt = "Nt",
                v = "--VIS--",
                vs = "Vs",
                V = "--VIS--",
                Vs = "Vs",
                ["\22"] = "^V",
                ["\22s"] = "^V",
                s = "S",
                S = "S_",
                ["\19"] = "^S",
                i = "--INS--",
                ic = "Ic",
                ix = "Ix",
                R = "R",
                Rc = "Rc",
                Rx = "Rx",
                Rv = "Rv",
                Rvc = "Rv",
                Rvx = "Rv",
                c = "C",
                cv = "Ex",
                r = "...",
                rm = "M",
                ["r?"] = "?",
                ["!"] = "!",
                t = "--TER--",
            },
            mode_colors = {
                n = "red",
                i = "green",
                v = "cyan",
                V = "cyan",
                ["\22"] = "cyan",
                c = "orange",
                s = "purple",
                S = "purple",
                ["\19"] = "purple",
                R = "orange",
                r = "orange",
                ["!"] = "red",
                t = "red",
            }
        },
        provider = function(self)
            return self.mode_names[self.mode]
        end,
        hl = function(self)
            local mode = self.mode:sub(1, 1)
            return { fg = self.mode_colors[mode], bold = true, bg = utils.get_highlight("StatusLine").fg }
        end,
        update = {
            "ModeChanged",
            pattern = "*:*",
            callback = vim.schedule_wrap(function()
                vim.cmd("redrawstatus")
            end),
        },
    }

    local MacroRec = {
        condition = function()
            return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
        end,
        provider = "  ",
        hl = { fg = "orange", bold = true },
        utils.surround({ "[", "]" }, nil, {
            provider = function()
                return vim.fn.reg_recording()
            end,
            hl = { fg = "green", bold = true },
        }),
        update = {
            "RecordingEnter",
            "RecordingLeave",
        },
    }

    local Diagnostics = {
        condition = conditions.has_diagnostics,
        static = {
            error_icon = get_icon("DiagnosticError"),
            warn_icon = get_icon("DiagnosticWarn"),
            hint_icon = get_icon("DiagnosticHint"),
            info_icon = get_icon("DiagnosticInfo"),
        },
        init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        end,
        update = { "DiagnosticChanged", "BufEnter" },
        { provider = " " },
        {
            provider = function(self)
                return self.errors > 0 and (" " .. self.error_icon .. self.errors)
            end,
            hl = { fg = utils.get_highlight("DiagnosticError").fg, bg = utils.get_highlight("StatusLine").fg },
        },
        {
            provider = function(self)
                return self.warnings > 0 and (" " .. self.warn_icon .. self.warnings)
            end,
            hl = { fg = utils.get_highlight("DiagnosticWarn").fg, bg = utils.get_highlight("StatusLine").fg },
        },
        {
            provider = function(self)
                return self.info > 0 and (" " .. self.info_icon .. self.info)
            end,
            hl = { fg = utils.get_highlight("DiagnosticInfo").fg, bg = utils.get_highlight("StatusLine").fg },
        },
        {
            provider = function(self)
                return self.hints > 0 and (" " .. self.hint_icon .. self.hints)
            end,
            hl = { fg = utils.get_highlight("DiagnosticHint").fg, bg = utils.get_highlight("StatusLine").fg },
        },
    }

    local GitBranch = {
        condition = conditions.is_git_repo,
        init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
        end,
        hl = { fg = utils.get_highlight("GitSignsChange").fg },
        provider = function(self)
            return "   " .. self.status_dict.head
        end,
    }

    local GitChanges = {
        condition = conditions.is_git_repo,
        init = function(self)
            self.status_dict = vim.b.gitsigns_status_dict
            self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
                self.status_dict.changed ~= 0
        end,
        hl = { fg = utils.get_highlight("GitSignsChange").fg },
        {
            condition = function(self)
                return self.has_changes
            end,
            provider = " (",
        },
        {
            provider = function(self)
                local count = self.status_dict.added or 0
                return count > 0 and ("+" .. count)
            end,
            hl = { fg = utils.get_highlight("GitSignsAdd").fg },
        },
        {
            provider = function(self)
                local count = self.status_dict.removed or 0
                return count > 0 and ("-" .. count)
            end,
            hl = { fg = utils.get_highlight("GitSignsDelete").fg },
        },
        {
            provider = function(self)
                local count = self.status_dict.changed or 0
                return count > 0 and ("+" .. count)
            end,
            hl = { fg = utils.get_highlight("GitSignsChange").fg },
        },
        {
            condition = function(self)
                return self.has_changes
            end,
            provider = ")",
        },
    }

    local FileType = {
        init = function(self)
            local filename = vim.fn.expand("%:t")
            local extension = vim.fn.fnamemodify(filename, ":e")
            self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension)
            self.filetype = vim.bo.filetype
        end,
        provider = function(self)
            return self.icon and (" " .. self.icon .. " " .. self.filetype)
        end,
        hl = function(self)
            return { fg = self.icon_color }
        end
    }

    local ShowCmd = {
        provider = "%3.5(%S%)",
    }

    local LSPActive = {
        condition = conditions.lsp_attached,
        update = { "LspAttach", "LspDetach" },
        provider = function()
            local names = {}
            for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
                table.insert(names, server.name)
            end
            return get_icon("ActiveLSP") .. " [" .. table.concat(names, " ") .. "] "
        end,
    }

    local Ruler = {
        provider = "%l:%c %P "
    }

    local ScrollBar = {
        static = {
            sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
        },
        provider = function(self)
            local curr_line = vim.api.nvim_win_get_cursor(0)[1]
            local lines = vim.api.nvim_buf_line_count(0)
            local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
            return string.rep(self.sbar[i], 2)
        end,
    }

    return {
        hl = { bg = utils.get_highlight("StatusLine").fg },
        ViMode,
        MacroRec,
        Diagnostics,
        GitBranch,
        GitChanges,
        FileType,
        { provider = "%=", },
        ShowCmd,
        { provider = "%=", },
        LSPActive,
        Ruler,
        ScrollBar
    }
end

local function is_valid(bufnr)
    if not bufnr then bufnr = 0 end
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

local function pattern_match(str, pattern_list)
    for _, pattern in ipairs(pattern_list) do
        if str:find(pattern) then return true end
    end
    return false
end

local buf_matchers = {
    filetype = function(pattern_list, bufnr) return pattern_match(vim.bo[bufnr or 0].filetype, pattern_list) end,
    buftype = function(pattern_list, bufnr) return pattern_match(vim.bo[bufnr or 0].buftype, pattern_list) end,
    bufname = function(pattern_list, bufnr)
        return pattern_match(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr or 0), ":t"), pattern_list)
    end,
}

local function buffer_matches(patterns, bufnr)
    for kind, pattern_list in pairs(patterns) do
        if buf_matchers[kind](pattern_list, bufnr) then return true end
    end
    return false
end

return {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
        return {
            disable_winbar_cb = function(args)
                return not is_valid(args.buf)
                    or buffer_matches({
                        buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
                        filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
                    }, args.buf)
            end,
            statusline = make_statusline(),
            -- winbar = make_statusline(),
            tabline = make_tabline(),
            -- statuscolumn = make_statusline(),
        }
    end,
}
