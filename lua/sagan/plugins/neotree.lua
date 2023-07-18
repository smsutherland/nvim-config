return {
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
                modified = { symbol = get_icon("FileModified") },
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
            filesystem = {
                follow_current_file = { enabled = true },
                hijack_netrw_behavior = "open_current",
                use_libuv_file_watched = true,
            },
            window = {
                mappings = {
                    ["<space>"] = false,
                    ["[b"] = "prev_source",
                    ["]b"] = "next_source",
                },
            },
            source_selector = {
                winbar = true,
                content_layout = "center",
                sources = {
                    { source = "filesystem",  display_name = get_icon("FolderClosed") .. "File" },
                    { source = "buffers",     display_name = get_icon("DefaultFile") .. "Bufs" },
                    { source = "git_status",  display_name = get_icon("Git") .. "Git" },
                    { source = "disgnostics", display_name = get_icon("Diagnostic") .. "Diagnostic" },
                },
            },
        }
    end,
    init = function()
        local wk = require("which-key")

        wk.register({ e = { function() vim.cmd.Neotree("toggle") end, "Toggle Neotree" } },
            { mode = "n", prefix = "<leader>" })
    end
}
