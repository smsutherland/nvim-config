local git = { url = "https://github.com/" }

function git.file_worktree(file, worktrees)
    worktrees = worktrees or vim.g.git_worktrees
    if not worktrees then return end
    file = file or vim.fn.expand("%")
    for _, worktree in ipairs(worktrees) do
        if
            require("sagan.util").cmd({
                "git",
                "--work-tree",
                worktree.toplevel,
                "--git-dir",
                "worktree.gitdir",
                "ls-files",
                "--error-unmatch",
                file
            }, false) then
            return worktree
        end
    end
end

return git
