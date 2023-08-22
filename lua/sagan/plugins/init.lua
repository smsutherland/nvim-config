return {
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("gruvbox")
        end,
    },
    "olimorris/onedarkpro.nvim",
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function(_, opts)
            vim.o.timeout = true
            vim.o.timeoutlen = 300

            local wk = require("which-key")

            wk.register({
                J = { ":m '>+1<CR>gv=gv", "Move selection down" },
                K = { ":m '<-2<CR>gv=gv", "Move selection up" },
            }, { mode = "v" })

            wk.register({
                H = { function() require("sagan.util.buffer").nav(-1) end, "Previous Buffer" },
                L = { function() require("sagan.util.buffer").nav(1) end, "Next Buffer" },
            }, { mode = "n" })

            wk.register({
                c = { function() require("sagan.util.buffer").close() end, "Close Buffer" },
                C = { function() require("sagan.util.buffer").close(0, true) end, "Force Close Buffer" },
            }, { mode = "n", prefix = "<leader>" })

            wk.register({
                m = { function()
                    if vim.opt.mouse._value == "nvi" then
                        vim.opt.mouse = nil
                    else
                        vim.opt.mouse = "nvi"
                    end
                end, "Toggle mouse usage" }
            }, { mode = "n", prefix = "<leader>" })
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
    {
        "numToStr/Comment.nvim",
        init = function()
            local wk = require("which-key")

            wk.register({
                ["/"] = {
                    function()
                        require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
                    end,
                    "Toggle comment line",
                },
            }, { mode = "n", prefix = "<leader>" })

            wk.register({
                ["/"] = {
                    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
                    "Toggle comment line",
                },
            }, { mode = "v", prefix = "<leader>" })
        end
    },
    "echasnovski/mini.bufremove",
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm", "ToggleTermSendCurrentLine", "ToggleTermSendVisualLines", "ToggleTermSendVisualSelection",
            "ToggleTermSetName", "ToggleTermToggleAll" },
        version = "*",
        init = function()
            local wk = require("which-key")

            wk.register({
                ["<f7>"] = { function() vim.cmd.ToggleTerm("direction=float") end, "ToggleTerm Float" },
                ["<C-`>"] = { function() vim.cmd.ToggleTerm("direction=horizontal") end, "ToggleTerm Bottom" },
            }, { mode = "n" })

            wk.register({
                ["<f7>"] = { function() vim.cmd.ToggleTerm("direction=float") end, "ToggleTerm Float" },
                ["<C-`>"] = { function() vim.cmd.ToggleTerm("direction=horizontal") end, "ToggleTerm Bottom" },

                ["<C-h>"] = { "<cmd>wincmd h<cr>", "Terminal left window navigation" },
                ["<C-j>"] = { "<cmd>wincmd j<cr>", "Terminal down window navigation" },
                ["<C-k>"] = { "<cmd>wincmd k<cr>", "Terminal up window navigation" },
                ["<C-l>"] = { "<cmd>wincmd l<cr>", "Terminal right window navigation" },

                ["<esc>"] = { [[<C-\><C-n>]], "Terminal go to normal mode." },
            }, { mode = "t" })
        end,
        opts = {
            shading_factor = 2,
            direction = "float",
            float_opts = { border = "rounded" },
        },
        config = true,
    },
    {
        "vimwiki/vimwiki",
        keys = "<leader>w",
        ft = "wiki"
    }
}
