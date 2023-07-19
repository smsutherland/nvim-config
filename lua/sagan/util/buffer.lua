M = {}

function M.nav(n)
    local current = vim.api.nvim_get_current_buf()
    for i, v in ipairs(vim.t.bufs) do
        if current == v then
            vim.cmd.b(vim.t.bufs[(i + n - 1) % #vim.t.bufs + 1])
            break
        end
    end
end

function M.is_valid(bufnr)
    if not bufnr then bufnr = 0 end
    return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

function M.close(bufnr, force)
    if not force and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
        local bufname = vim.fn.expand("%")
        local empty = bufname == ""
        if empty then bufname = "Untitled" end
        local confirm = vim.fn.confirm(('Save changes to "%s"'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
        if confirm == 1 then
            if empty then return end
            vim.cmd.write()
        elseif confirm == 2 then
            force = true
        else
            return
        end
    end
    require("mini.bufremove").delete(bufnr, force)
end

return M
