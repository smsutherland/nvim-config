local get_icon = require("sagan.icons").get_icon
return {
    "lewis6991/gitsigns.nvim",
    event = "User GitFile",
    opts = {
        signs = {
            add = { text = get_icon("GitSign") },
            change = { text = get_icon("GitSign") },
            delete = { text = get_icon("GitSign") },
            topdelete = { text = get_icon("GitSign") },
            changedelete = { text = get_icon("GitSign") },
            untracked = { text = get_icon("GitSign") },
        },
        worktrees = vim.g.git_worktrees,
    },
}
