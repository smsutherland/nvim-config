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
            tabline = make_tabline(),
        }
    end,
}
