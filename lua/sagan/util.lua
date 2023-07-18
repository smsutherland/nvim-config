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

return M
