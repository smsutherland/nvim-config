return {
    {
        "olimorris/onedarkpro.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("onedark_vivid")
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300

            local wk = require("which-key")

            wk.register({
                J = { ":m '>+1<CR>gv=gv", "Move selection down" },
                K = { ":m '<-2<CR>gv=gv", "Move selection up" },
            }, { mode = "v" })
        end,
        opts = {}
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        init = function()
            local wk = require("which-key")

            wk.register({
                u = {
                    function()
                        vim.cmd.UndotreeToggle()
                        vim.cmd.UndotreeFocus()
                    end, "Toggle Undotree"
                }
            }, { mode = "n", prefix = "<leader>" })
        end
    },
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        init = function()
            local wk = require("which-key")

            wk.register({
                g = {
                    name = "git",
                    g = { vim.cmd.LazyGit, "Open LazyGit" }
                },
            }, { mode = "n", prefix = "<leader>" })
        end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
}
