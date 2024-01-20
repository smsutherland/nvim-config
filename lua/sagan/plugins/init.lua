return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        opts = {
            flavour = "frappe",
            background = {
                light = "latte",
                dark = "frappe",
            },
            transparent_background = false,
            show_end_of_buffer = true,
            term_colors = true,
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.15,
            },
            styles = {
                comments = { "italic" },
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                neotree = true,
                treesitter = true,
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                    inlay_hints = {
                        background = true,
                    },
                },
                telescope = {
                    enabled = true,
                },
                which_key = true,
            }
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme("gruvbox")
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
        ft = "wiki",
        cmd = { "VimwikiIndex", "VimwikiTabIndex", "VimwikiUISelect", "VimwikiVar", "VimwikiDiaryIndex",
            "VimwikiMakeDiaryNote", "VimwikiTabMakeDiaryNote", "VimwikiMakeYesterdayDiaryNote",
            "VimwikiMakeTomorrowDiaryNote" },
        init = function()
            local wk = require("which-key")

            wk.register({
                w = {
                    name = "vimwiki",
                    w = { "<cmd>VimwikiIndex<cr>", "Open default wiki index file" },
                    t = { "<cmd>VimwikiTabIndex<cr>", "Open default wiki index file in a new tab" },
                    s = { "<cmd>VimwikiUISelect<cr>", "Select and open wiki index file" },
                    i = { "<cmd>VimwikiDiaryIndex", "Open default diary index" },
                    ["<leader>"] = {
                        name = "More vimwiki",
                        i = { "<cmd>VimwikiDiaryGenerateLinks<cr>", "Generate diary links" },
                        w = { "<cmd>VimwikiMakeDiaryNote<cr>", "Make diary note" },
                        t = { "<cmd>VimwikiTabMakeDiaryNote<cr>", "Make diary note in new tab" },
                        y = { "<cmd>VimwikiMakeYesterdayDiaryNote<cr>", "Make diary note for yesterday" },
                        m = { "<cmd>VimwikiMakeTomorrowDiaryNote<cr>", "Make diary note for tomorrow" },
                    }
                }
            }, { mode = "n", prefix = "<leader>" })
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        dependencies = {
            "zbirenbaum/copilot.lua",
            "hrsh7th/nvim-cmp",
        },
        config = function(_, opts)
            require("copilot_cmp").setup(opts)
        end,
    },
    {
        "mg979/vim-visual-multi",
        event = "VeryLazy",
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "BufEnter",
        dependencies = { "nvim-tree/nvim-web-devicons", "arkav/lualine-lsp-progress" },
        opts = {
            options = {
                theme = "catppuccin",
            },
            sections = {
                lualine_c = {
                    "filename",
                    "lsp_progress",
                },
            },
        },
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function(_, opts)
            require("colorizer").setup()
        end,
    }
}
