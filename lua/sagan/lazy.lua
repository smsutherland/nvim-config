local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function()
            local actions = require("telescope.actions")
            return {
                defaults = {
                    layout_config = {
                        horizontal = { prompt_position = "top", preview_width = 0.55, },
                        vertical = { mirror = false, },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    sorting_strategy = "ascending",
                    mappings = {
                        n = { q = actions.close },
                        i = {
                            ["<esc>"] = actions.close,
                            ["<C-l>"] = actions.cycle_history_next,
                            ["<C-h>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
            }
        end,
        setup = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)
        end
    },
    {
        "olimorris/onedarkpro.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("onedark_vivid")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "lua", "rust" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        "nvim-treesitter/playground",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = function()
            local get_icon = require("sagan.icons").get_icon

            return {
                close_if_last_window = true,
                default_component_configs = {
                    icon = {
                        folder_closed = get_icon("FolderClosed"),
                        folder_open = get_icon("FolderOpen"),
                        folder_empty = get_icon("FolderEmpty"),
                        folder_empty_open = get_icon("FolderEmpty"),
                        default = get_icon("DefaultFile"),
                    },
                    git_status = {
                        symbols = {
                            added = get_icon("GitAdd"),
                            deleted = get_icon("GitDelete"),
                            modified = get_icon("GitChange"),
                            renamed = get_icon("GitRenamed"),
                            untracked = get_icon("GitUntracked"),
                            ignored = get_icon("GitIgnored"),
                            unstaged = get_icon("GitUnstaged"),
                            staged = get_icon("GitStaged"),
                            conflict = get_icon("GitConflict"),
                        },
                    },
                },
            }
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },
    "mbbill/undotree",
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end

            return {
                mapping = {
                    ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
                    ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                    ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                    ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
                    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-y>"] = cmp.config.disable,
                    ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
                    ["<CR>"] = cmp.mapping.confirm { select = false },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
            }
        end
    },
    "stevearc/dressing.nvim",
}, { defaults = { lazy = true } })
