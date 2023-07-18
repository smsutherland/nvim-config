local nerd = {
    ActiveLSP = "",
    ActiveTS = "",
    ArrowLeft = "",
    ArrowRight = "",
    Bookmarks = "",
    BufferClose = "󰅖",
    DapBreakpoint = "",
    DapBreakpointCondition = "",
    DapBreakpointRejected = "",
    DapLogPoint = ".>",
    DapStopped = "󰁕",
    Debugger = "",
    DefaultFile = "󰈙",
    Diagnostic = "󰒡",
    DiagnosticError = "",
    DiagnosticHint = "󰌵",
    DiagnosticInfo = "󰋼",
    DiagnosticWarn = "",
    Ellipsis = "…",
    FileNew = "",
    FileModified = "",
    FileReadOnly = "",
    FoldClosed = "",
    FoldOpened = "",
    FoldSeparator = " ",
    FolderClosed = "",
    FolderEmpty = "",
    FolderOpen = "",
    Git = "󰊢",
    GitAdd = "",
    GitBranch = "",
    GitChange = "",
    GitConflict = "",
    GitDelete = "",
    GitIgnored = "◌",
    GitRenamed = "➜",
    GitSign = "▎",
    GitStaged = "✓",
    GitUnstaged = "✗",
    GitUntracked = "★",
    LSPLoading1 = "",
    LSPLoading2 = "󰀚",
    LSPLoading3 = "",
    MacroRecording = "",
    Package = "󰏖",
    Paste = "󰅌",
    Refresh = "",
    Search = "",
    Selected = "❯",
    Session = "󱂬",
    Sort = "󰒺",
    Spellcheck = "󰓆",
    Tab = "󰓩",
    TabClose = "󰅙",
    Terminal = "",
    Window = "",
    WordFile = "󰈭",
}

local text = {
    ActiveLSP = "LSP:",
    ArrowLeft = "<",
    ArrowRight = ">",
    BufferClose = "x",
    DapBreakpoint = "B",
    DapBreakpointCondition = "C",
    DapBreakpointRejected = "R",
    DapLogPoint = "L",
    DapStopped = ">",
    DefaultFile = "[F]",
    DiagnosticError = "X",
    DiagnosticHint = "?",
    DiagnosticInfo = "i",
    DiagnosticWarn = "!",
    Ellipsis = "...",
    FileModified = "*",
    FileReadOnly = "[lock]",
    FoldClosed = "+",
    FoldOpened = "-",
    FoldSeparator = " ",
    FolderClosed = "[D]",
    FolderEmpty = "[E]",
    FolderOpen = "[O]",
    GitAdd = "[+]",
    GitChange = "[/]",
    GitConflict = "[!]",
    GitDelete = "[-]",
    GitIgnored = "[I]",
    GitRenamed = "[R]",
    GitSign = "|",
    GitStaged = "[S]",
    GitUnstaged = "[U]",
    GitUntracked = "[?]",
    MacroRecording = "Recording:",
    Paste = "[PASTE]",
    Search = "?",
    Selected = "*",
    Spellcheck = "[SPELL]",
    TabClose = "X",
}

return {
    nerd = nerd,
    text = text,
    get_icon = function(name)
        if vim.g.icons == "nerd" then
            return nerd[name]
        elseif vim.g.icons == "text" then
            return text[name]
        end
    end,
}
