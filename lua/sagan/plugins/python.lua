return {
    {
        "luk400/vim-jukit",
        ft = { "json", "python" },
        config = function()
            vim.g.jukit_mpl_style = vim.fn["jukit#util#plugin_path"]() ..
                '/helpers/matplotlib-backend-kitty/backend.mplstyle'
            local wk = require("which-key")

            wk.register({
                n = {
                    p = { function() vim.fn["jukit#convert#notebook_convert"]("jupyter-notebook") end,
                        "Convert between .ipynb and .py" },
                    c = {
                        name = "cell operations",
                        o = { function() vim.fn["jukit#cells#create_below"](0) end, "Create a new code cell below" },
                        O = { function() vim.fn["jukit#cells#create_above"](0) end, "Create a new code cell above" },
                        t = { function() vim.fn["jukit#cells#create_below"](1) end, "Create a new markdown cell below" },
                        T = { function() vim.fn["jukit#cells#create_above"](1) end, "Create a new markdown cell above" },
                        d = { vim.fn["jukit#cells#delete"], "Delete current cell" },
                        m = { vim.fn["jukit#cells#merge_below"], "Merge with the cell below" },
                        M = { vim.fn["jukit#cells#merge_above"], "Merge with the cell above" },
                        j = { vim.fn["jukit#cells#move_down"], "Move cell down" },
                        k = { vim.fn["jukit#cells#move_up"], "Move cell up" },
                        s = { vim.fn["jukit#cells#split"], "Split cell" },
                    },
                    j = { vim.fn["jukit#cells#jump_to_next_cell"], "Jump to next cell" },
                    k = { vim.fn["jukit#cells#jump_to_previous_cell"], "Jump to previous cell" },
                    ["<space>"] = { function() vim.fn["jukit#send#section"](0) end, "Send cell to output split" },
                    o = {
                        name = "Output",
                        s = { vim.fn["jukit#splits#output"], "Open output split" },
                        x = { vim.fn["jukit#splits#close_output_split"], "Close output split" },
                    }
                }
            }, { mode = "n", prefix = "<leader>" })
        end,
    },
}
