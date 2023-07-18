return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "User File",
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
        cmd = "TSPlaygroundToggle",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
}
