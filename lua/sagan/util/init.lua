M = {}

function M.load_plugin_with_func(plugin, module, func_names)
    if type(func_names) == "string" then func_names = { func_names } end
    for _, func in ipairs(func_names) do
        local old_func = module[func]
        module[func] = function(...)
            module[func] = old_func
            require("lazy").load { plugins = { plugin } }
            module[func](...)
        end
    end
end

function M.cmd(cmd, show_error)
    if type(cmd) == "string" then cmd = { cmd } end
    if vim.fn.has("win32") == 1 then cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd) end
    local result = vim.fn.system(cmd)
    local success = vim.api.nvim_get_vvar("shell_error") == 0
    if not success and (show_error == nil or show_error) then
        vim.api.nvim_err_writeln(("Error running command %s\nError message:\n%s"):format(table.concat(cmd, " "), result))
    end
    return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

return M
