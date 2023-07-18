local wk = require("which-key")

wk.register({
    u = {
        function()
            vim.cmd.UndotreeToggle()
            vim.cmd.UndotreeFocus()
        end, "Toggle Undotree"
    }
}, { mode = "n", prefix = "<leader>" })
