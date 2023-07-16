local lsp = require("lsp-zero").preset({})
lsp.on_attach(function(client, bufnr)
--    lsp.default_keymaps({buffer = bufnr})
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
end)

lsp.setup_servers({"rust_analyzer"})

require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
