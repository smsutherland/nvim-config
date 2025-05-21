--------------------------------------
--------------OPTIONS-----------------
--------------------------------------

-- Set <leader> and <localleader> to ' '.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- I have a nerd font! Let's use it.
vim.g.have_nerd_fomt = true

-- Display relative line numbers.
vim.o.number = true
vim.o.relativenumber = true

-- Let vim use the system clipboard.
-- Here, vim.schedule means that it doesn't happen immediately. Instead, it happens once we hit the UiEnter event.
-- This increases startup time by delaying this action.
-- We won't be copying anything until that point, so it doesn't affect anything user-facing.
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- When wrapping lines, indent the wrap to the same as the original line.
vim.o.breakindent = true

-- Store undo history in a file, so that it persists between sessions.
vim.o.undofile = true

-- Always have a sign column
-- TODO: What is that?
vim.o.signcolumn = "yes"

-- Show whitespaces.
-- tab   = tabs
-- trail = trailing spaces
-- nbsp  = non-breaking spaces
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- When doing a substitution ':s', show the changes being made live in the buffer, before finalizing the command.
-- "split" means we also create a new window to show all the changes, even ones we can't currently see.
-- The new window goes away once the command is run or canceled.
vim.o.inccommand = "split"

-- Highlight the line the cursor is on.
vim.o.cursorline = true

-- Keep at least 10 lines between the cursor and the top/bottom of the window.
vim.o.scrolloff = 10

-- When quitting without saving, ask if we should save rather than just failing.
-- ':q!' still quits without saving.
vim.o.confirm = true

--------------------------------------
--------------KEYBINDS----------------
--------------------------------------

-- When in normal mode "n", hit escape "<esc>" to turn off highlights from a search.
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>")

--------------------------------------
------------AUTOCOMMANDS--------------
--------------------------------------
-- See :h lua-guide-autocommands

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

--------------------------------------
--------------LSP-CONFIG--------------
--------------------------------------

--------------------------------------
---------------LAZY.NVIM--------------
--------------------------------------

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
  {
    -- Treesitter gives us better syntax highlighting
    'nvim-treesitter/nvim-treesitter',
    -- When updating or installing the plugin, run ":TSUpdate"
    build = ":TSUpdate",
    -- Call "nvim-treesitter.configs.setup(opts)" instead of "nvim-treesitter.setup(opts)"
    main = "nvim-treesitter.configs",
    opts = {
      -- These parsers should always be installed.
      ensure_installed = { "vim", "vimdoc", "lua" },
      highlight = {
        -- use treesitter to highlight, rather than default vim highlighting.
        enable = true,
      },
    },
  },
  {
    -- catppuccin colorscheme
    "catppuccin/nvim",
    -- The plugin is called "catppuccin", not "nvim"
    name = "catppuccin",
    -- This plugin is not lazy. It will be loaded on start up with a high priority.
    priority = 1000,
    opts = {
      -- I like to have mocha as my default catppuccin colorscheme
      -- The other flavors are available as catppuccin-<flavor>
      flavour = "mocha"
    },
    -- When the plugin loads on startup, set it up and set the colorscheme.
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    -- autocompletion
    'saghen/blink.cmp',
    -- Only load this plugin once the startup process is complete.
    event = "VimEnter",
    -- If we don't specify a version here, then we have to compile the rust portion of the plugin on every update.
    version = "1.*",
    opts = {
      sources = {
        -- Where do we want to autocomplete from?
        default = { "lsp", "path", "snippets" },
      },
      keymap = {
        preset = "enter",
      },
    },
  },
  {
    -- Default LSP configs and utilities.
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").lua_ls.setup({
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path.."/.luarc.json") or vim.uv.fs_stat(path.."/.luarc.jsonc")) then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you"re using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT"
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      })

      require("lspconfig").rust_analyzer.setup({})
    end,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ["-"] = { "actions.parent", mode = "n" },
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
  }
})

-- vim: ts=2 sts=2 sw=2 et
