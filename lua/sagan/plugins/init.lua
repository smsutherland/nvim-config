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
        end,
        opts = {}
    },
    { "mbbill/undotree", cmd = "UndotreeToggle" },
    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
}
