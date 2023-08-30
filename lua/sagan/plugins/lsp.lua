return {
    {
        "VonHeikemen/lsp-zero.nvim",
        event = "User File",
        branch = "v2.x",
        config = function()
            local get_icon = require("sagan.icons").get_icon
            local signs = {
                {
                    name = "DiagnosticSignError",
                    text = get_icon("DiagnosticError"),
                    texthl =
                    "DiagnosticSignError"
                },
                {
                    name = "DiagnosticSignWarn",
                    text = get_icon("DiagnosticWarn"),
                    texthl =
                    "DiagnosticSignWarn"
                },
                {
                    name = "DiagnosticSignHint",
                    text = get_icon("DiagnosticHint"),
                    texthl =
                    "DiagnosticSignHint"
                },
                {
                    name = "DiagnosticSignInfo",
                    text = get_icon("DiagnosticInfo"),
                    texthl =
                    "DiagnosticSignInfo"
                },
                { name = "DapStopped",             text = get_icon("DapStopped"),             texthl = "DiagnosticWarn" },
                { name = "DapBreakpoint",          text = get_icon("DapBreakpoint"),          texthl = "DiagnosticInfo" },
                { name = "DapBreakpointRejected",  text = get_icon("DapBreakpointRejected"),  texthl = "DiagnosticError" },
                { name = "DapBreakpointCondition", text = get_icon("DapBreakpointCondition"), texthl = "DiagnosticInfo" },
                { name = "DapLogPoint",            text = get_icon("DapLogPoint"),            texthl = "DiagnosticInfo" },
            }

            for _, sign in ipairs(signs) do
                vim.fn.sign_define(sign.name, sign)
            end
            vim.diagnostic.config({
                virtual_text = true,
                signs = { active = signs },
                update_in_insert = true,
                underline = true,
                severity_sort = true,
                float = {
                    focused = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = ","
                },
            })
        end
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = { "L3MON4D3/LuaSnip", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-nvim-lsp" },
        config = function()
            require("lsp-zero.cmp").extend()
            local cmp = require("cmp")
            local cmp_action = require("lsp-zero.cmp").action()
            local luasnip = require("luasnip")

            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
            end


            cmp.setup({
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
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip",  priority = 750 },
                    { name = "buffer",   priority = 500 },
                    { name = "path",     priority = 250 },
                    { name = "omni" },
                }),
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        cmd = "LspInfo",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lsp = require("lsp-zero")

            lsp.on_attach(function(_, bufnr)
                local wk = require("which-key")

                local format_opts = {
                    format_on_save = { enabled = true },
                    disabled = {},
                }

                wk.register({
                    g = {
                        d = { vim.lsp.buf.definition, "Go to Definition" },
                    },
                    K = { vim.lsp.buf.hover, "Hover Documentation" }
                }, { mode = "n", buffer = bufnr }
                )

                wk.register({
                    l = {
                        name = "LSP",
                        a = { vim.lsp.buf.code_action, "Code Actions" },
                        r = { vim.lsp.buf.rename, "Rename" },
                        d = { vim.diagnostic.open_float, "Show Diagnostics" },
                        D = { function() require("telescope.builtin").diagnostics() end, "Show All Diagnostics" },
                        s = { function() require("telescope.builtin").lsp_document_symbols() end, "Show Symbols" },
                        f = { function() vim.lsp.buf.format(format_opts) end, "Format" },
                    }
                }, { mode = "n", prefix = "<leader>", buffer = bufnr })

                vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
                    vim.lsp.buf.format(format_opts)
                end, { desc = "Format file with LSP" })

                vim.api.nvim_create_autocmd("BufWritePre", {
                    desc = "autoformat on save",
                    group = vim.api.nvim_create_augroup("format on save", { clear = true }),
                    callback = function() vim.lsp.buf.format(format_opts) end,
                })
            end)

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
            lspconfig.rust_analyzer.setup({})
            lspconfig.pyright.setup({
                on_attach = function(client)
                    client.server_capabilities.completionProvider = false
                end,
            })
            lspconfig.jedi_language_server.setup({})

            lsp.setup()
        end
    },
    {
        "stevearc/dressing.nvim",
        init = function()
            require("sagan.util").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" })
        end,
        opts = {
            input = { default_prompt = "➤ " },
            select = { backend = { "telescope", "builtin" } },
        },
    },
    {
        "simrat39/rust-tools.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        ft = { "rust" },
        opts = function()
            local rt = require("rust-tools")
            local wk = require("which-key")
            return {
                executor = require("rust-tools.executors").toggleterm,
                server = {
                    on_attach = function(_, bufnr)
                        wk.register({
                            a = { rt.code_action_group.code_action_group, "" },
                        }, { mode = "n", prefix = "<leader>", buffer = bufnr })

                        wk.register({
                            ["<C-space>"] = { rt.hover_actions.hover_actions, "" },
                        }, { mode = "n", buffer = bufnr })
                    end,
                }
            }
        end,
        config = function(_, opts)
            local rt = require("rust-tools")
            rt.setup(opts)
            rt.inlay_hints.enable()
        end,
    },
    {
        "lervag/vimtex",
        ft = "tex",
    },
}
