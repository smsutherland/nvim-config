return {
    {
        "VonHeikemen/lsp-zero.nvim",
        event = "User File",
        branch = "v2.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
        },
        init = function()
            local wk = require("which-key")
            local lsp = require("lsp-zero").preset({ setup_servers_on_start = false })
            lsp.on_attach(function(client, bufnr)
                local format_opts = {
                    format_on_save = { enabled = true },
                    disabled = {},
                }

                wk.register(
                    {
                        g = {
                            d = { vim.lsp.buf.definition, "Go to Definition" },
                        },
                    },
                    { mode = "n", buffer = bufnr }
                )

                wk.register({
                    l = {
                        name = "LSP",
                        a = { vim.lsp.buf.code_action, "Code Actions" },
                        r = { vim.lsp.buf.rename, "Rename" },
                        d = { vim.lsp.diagnostic.open_float, "Show Diagnostics" },
                        s = { function() require("telescope.builtin").lsp_document_symbols() end, "Show Symbols" },
                        f = { function() vim.lsp.buf.format(format_opts) end, "Format" },
                    }
                }, { mode = "n", prefix = "<leader>", buffer = bufnr })

                wk.register({
                    K = { vim.lsp.buf.hover, "Hover Documentation" }
                }, { mode = "n" })

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

            lsp.setup_servers({ "rust_analyzer" })

            lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

            lsp.setup()
        end
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
}
