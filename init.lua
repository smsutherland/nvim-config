--------------------------------------
--------------OPTIONS-----------------
--------------------------------------

-- Set <leader> and <localleader> to ' '.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- I have a nerd font! Let's use it.
vim.g.have_nerd_font = true

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
-- Don't wrap lines by default
vim.o.wrap = false

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

-- Set tabs to be 4 spaces
vim.o.ts = 4
vim.o.sts = 4
vim.o.sw = 4
-- replace tabs with spaces
vim.o.et = true

-- When searching, be case-insensitive...
vim.o.ignorecase = true
-- ...unless our search query has different cases in it.
vim.o.smartcase = true

-- Only worry about neovide-specific options if we're actually in neovide.
if vim.g.neovide then
  -- Make neovide text smaller
  vim.g.neovide_scale_factor = 0.8
end

--------------------------------------
--------------KEYBINDS----------------
--------------------------------------

-- When in normal mode "n", hit escape "<esc>" to turn off highlights from a search.
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>")

-- open oil in a floating window.
-- <C-c> to close it up again.
-- "g?" to see keymaps while in Oil.
vim.keymap.set("n", "-",
  function()
    require("oil").open_float()
  end, { desc = "Open Oil" })

-- Telescope keybinds for searching files

-- Find files.
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, { desc = "[F]ind [F]iles" })

-- Find files including hidden or ignored files.
vim.keymap.set("n", "<leader>fF", function()
  require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end, { desc = "[F]ind All [F]iles" })

-- Use ripgrep to search for a string in all files.
vim.keymap.set("n", "<leader>fw", function()
  require("telescope.builtin").live_grep()
end, { desc = "Ripgrep" })

-- Use ripgrep to search for a string in all files.
vim.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "[B]uffers" })

--------------------------------------
------------AUTOCOMMANDS--------------
--------------------------------------
-- See :h lua-guide-autocommands

-- Highlight text when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
  end,
})

-- LaTeX autocmd
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "set settings for LaTeX",
  pattern = { "*.tex", },
  group = vim.api.nvim_create_augroup("LaTeX", { clear = true }),
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"

    local wk = require("which-key")
    wk.add({ "<localleader>l", group = "[L]atex", icon = { icon = "", color = "green" } })
  end,
})

-- Wiki autocmd
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  desc = "set settings for wiki",
  pattern = { "*.wiki", },
  group = vim.api.nvim_create_augroup("wiki", { clear = true }),
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})

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
    ---@module "nvim-treesitter"
    ---@type TSConfig
    opts = {
      -- These parsers should always be installed.
      ensure_installed = { "vim", "vimdoc", "lua", "latex", "bibtex" },
      highlight = {
        -- use treesitter to highlight, rather than default vim highlighting.
        enable = true,
        disable = { "latex" },
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
    ---@module "catppuccin"
    ---@type CatppuccinOptions
    opts = {
      -- I like to have mocha as my default catppuccin colorscheme
      -- The other flavors are available as catppuccin-<flavor>
      flavour = "mocha",
      integrations = {
        blink_cmp = true,
        treesitter = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        telescope = {
          enabled = true,
        },
        which_key = true,
      },
      kitty = true,
    },
    -- When the plugin loads on startup, set it up and set the colorscheme.
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    -- autocompletion
    "saghen/blink.cmp",
    -- Only load this plugin once the startup process is complete.
    event = "VimEnter",
    -- If we don't specify a version here, then we have to compile the rust portion of the plugin on every update.
    version = "1.*",
    ---@module "blink-cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        -- Where do we want to autocomplete from?
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        }
      },
      appearance = {
        -- Adjusts spacing for the monospace font.
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500, },
      },
      keymap = {
        preset = "enter",
      },
      signature = { enabled = true },
    },
    dependencies = {
      -- We don't need to load lazydev every time we load blink.cmp.
      -- We only want it if we have a lua file.
      -- That's why we don't specify it as a dependency here.
      -- It seems to work just fine.
      -- {
      --   "folke/lazydev.nvim",
      --   ft = "lua",
      -- },
    }
  },
  {
    -- Default LSP configs and utilities.
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Allow completion functionality.
      "saghen/blink.cmp",
    },
    config = function()
      local blink_capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Set up lua-language-server
      require("lspconfig").lua_ls.setup({
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath("config") and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
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
        capabilities = blink_capabilities,
        settings = {
          Lua = {
            completion = { callSnipped = "Replace", },
            diagnostics = { disable = { "missing-fields" } },
          }
        }
      })

      require("lspconfig").rust_analyzer.setup({
        capabilities = blink_capabilities,
      })

      vim.lsp.enable("ruff")
      vim.lsp.enable("ty")
      vim.lsp.enable("pyright")
      -- Function which calls when an LSP attaches to a buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-mappings", { clear = true }),
        -- The actual function which calls on an LSP attaching.
        callback = function(event)
          -- Set keybinds through which-key to better use its features.
          local wk = require("which-key")

          -- Lazily require telescope, otherwise it loads immediately.
          ---@param fun string
          ---@return function
          local function telescope(fun)
            return function()
              require("telescope.builtin")[fun]()
            end
          end

          -- Add all binds in a single wk call.
          wk.add({
            {
              mode = "n",
              buffer = event.buf,
              -- All the binds in the group.
              -- Note that we have to specify "<leader>c" even though they are in the group.
              { "<leader>cr", vim.lsp.buf.rename,                 desc = "[R]ename" },
              { "<leader>ca", vim.lsp.buf.code_action,            desc = "[C]ode [A]ction" },
              { "<leader>cs", telescope("lsp_document_symbols"),  desc = "Document [S]ymbols" },
              { "<leader>cS", telescope("lsp_workspace_symbols"), desc = "Workspace [S]ymbols" },
              { "<leader>cd", vim.diagnostic.open_float,          desc = "Show [D]iagnostics" },
              { "<leader>cD", telescope("diagnostics"),           desc = "Show All [D]iagnostics" },
            },
            {
              buffer = event.buf,
              mode = "n",
              { "grr", telescope("lsp_references"),       desc = "[G]oto [R]eferences" },
              { "gri", telescope("lsp_implementations"),  desc = "[G]oto [I]mplementations" },
              { "grd", telescope("lsp_definitions"),      desc = "[G]oto [D]efinition" },
              { "gy",  telescope("lsp_type_definitions"), desc = "[G]oto t[Y]pe Definitions" },
              { "gd",  vim.lsp.buf.definition,            desc = "[G]oto [D]efinition" },
            }
          })

          -- Our LSP client
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Only provide the option to toggle inlay hints if the LSP supports inlay hints.
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            wk.add({
              "<leader>ui",
              function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
              end,
              mode = "n",
              buffer = event.buf,
              desc = "[T]oggle [I]nlay Hints",
              -- which-key feature: set an icon for the binding.
              -- If inlay hints are enabled, green on switch.
              -- Otherwise, yellow off switch.
              icon = function()
                return vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }) and { icon = "󰔢", color = "green" } or
                    { icon = "󰨚", color = "yellow" }
              end,
            })
          end

          -- Only bind a formatting key if the lsp supports it.
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting, event.buf) then
            wk.add({
              "<leader>cf",
              mode = "n",
              vim.lsp.buf.format,
              buffer = event.buf,
              desc = "[F]ormat",
            })
          end
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.INFO] = '󰋽',
            [vim.diagnostic.severity.HINT] = '󰌶',
          }
        },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })
    end,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo" },
  },
  {
    -- File explorer
    "stevearc/oil.nvim",
    cmd = "Oil",
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      skip_confirm_for_simple_edits = true,
      float = {
        -- Only use 50% of the height and width to display the float
        max_height = 0.5,
        max_width = 0.5,
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  },
  {
    -- Key preview.
    "folke/which-key.nvim",
    -- Only load once vim has finished initializing.
    event = "VimEnter",
    ---@module "which-key"
    ---@type wk.Opts
    opts = {
      -- put the which-key display in the bottom right.
      preset = "helix",
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = {},
      },
      spec = {
        { "<leader>c", group = "[C]ode", icon = "󰅩" },
        { "<leader>f", group = "[F]ind", icon = "󰍉" },
        { "<leader>u", group = "[U]i", icon = { icon = "󰙵", color = "cyan" } },
        { "<leader>w", group = "Vim[W]iki", icon = { icon = "󰖬", color = "green" } },
        { "g", group = "[G]o" }
      }
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd = { "Telescope" },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55, },
            vertical = { mirror = false, },
            width = 0.87,
            height = 0.8,
            preview_cutoff = 120,
          },
          sorting_strategy = "ascending",
        },
        extensions = {
          -- use a native fzf made just for telescope, allowing us to find things faster.
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          -- I set this up so that lsp.code_action uses a little telescope popup.
          -- I don't know how to get it to only do this to lsp.code_action.
          -- I'd imagine there are some ui selections which I don't want to have as telescope and to popup by my cursor.
          ["ui-select"] = {
            require("telescope.themes").get_cursor(),
          },
        },
      })

      -- These have to go after setup in order for telescope to work right.
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
  },
  {
    -- Better lua_ls for nvim config.
    "folke/lazydev.nvim",
    ft = "lua",
    ---@module "lazydev"
    ---@type lazydev.Config
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found.
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      }
    },
  },
  {
    "lervag/vimtex",
    -- vimtex doesn't handle lazy loading well.
    lazy = false,
    config = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
      vim.g.vimtex_quickfix_method = "pplatex"
      vim.g.vimtex_view_method = "zathura"
    end,
    keys = {
      { "<localleader>l", "", desc = "+vimtex", ft = "tex" },
    }
  },
  {
    "vimwiki/vimwiki",
    ft = "vimwiki",
    cmd = {
      -- All global vimwiki commands.
      -- See :h vimwiki-global-commands.
      "VimwikiMakeTomorrowDiaryNote",
      "VimwikiMakeYesterdayDiaryNote",
      "VimwikiTabMakeDiaryNote",
      "VimwikiMakeDiaryNote",
      "VimwikiDiaryIndex",
      "VimwikiVar",
      "VimwikiUISelect",
      "VimwikiTabIndex",
      "VimwikiIndex",
    },
    keys = {
      { "<leader>wi", desc = "VimwikiDiaryIndex" },
      { "<leader>ws", desc = "VimwikiUISelect" },
      { "<leader>wt", desc = "VimwikiTabIndex" },
      { "<leader>ww", desc = "VimwikiIndex" },
    },
  },
  {
    "knubie/vim-kitty-navigator",
    build = "cp ./*.py ~/.config/kitty/",
    init = function()
      vim.g.kitty_navigator_no_mappings = 1
    end,
    keys = {
      { "<c-`>h", "<cmd>KittyNavigateLeft<cr>",  silent = true },
      { "<c-`>j", "<cmd>KittyNavigateDown<cr>",  silent = true },
      { "<c-`>k", "<cmd>KittyNavigateUp<cr>",    silent = true },
      { "<c-`>l", "<cmd>KittyNavigateRight<cr>", silent = true },
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
