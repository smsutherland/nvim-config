local wk = require("which-key")
local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
    local format_opts = {
        format_on_save = { enabled = true },
        disabled = {},
    }

    wk.register({
        g = {
            d = { vim.lsp.buf.definition, "Go to Definition" },
        },
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

lsp.setup_servers({ "rust_analyzer" })

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
