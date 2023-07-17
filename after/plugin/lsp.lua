local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
    -- lsp.default_keymaps({buffer = bufnr})
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>ls", function()
        require("telescope.builtin").lsp_document_symbols()
    end)

    local format_opts = {
        format_on_save = { enabled = true },
        disabled = {},
    }

    vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format(format_opts)
    end)
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
