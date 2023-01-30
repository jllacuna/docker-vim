local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  vim.notify "packer not found"
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use {
    "lewis6991/impatient.nvim", -- Speed up loading lua plugins
    config = function () require("impatient") end,
  }
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim"    -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"  -- Useful lua functions used by lots of plugins
  use {
    "kyazdani42/nvim-web-devicons", -- Be able to show icons from Nerd Fonts in plugins
    config = function () require("user.devicons") end,
  }
  use "tpope/vim-repeat"       -- Allows plugins to be repeated with "."
  use "RRethy/vim-illuminate"  -- Highlight other instances of the word under cursor
  use "b0o/schemastore.nvim"   -- JSON schemas from schemastore.org
  use {
    "windwp/nvim-autopairs",   -- Autopairs, integrates with both cmp and treesitter
    config = function () require("user.autopairs") end,
  }
  use {
    "numToStr/Comment.nvim",   -- Easily comment stuff
    config = function () require("user.comment") end,
  }
  use "godlygeek/tabular"      -- Vertically align characters
  use {
    "kyazdani42/nvim-tree.lua", -- File explorer
    config = function () require("user.tree") end,
  }
  use {
    "nvim-lualine/lualine.nvim", -- Status line
    config = function () require("user.lualine") end,
  }
  use {
    "kdheepak/tabline.nvim", -- Buffer and Tab line
    config = function () require("user.tabline") end,
  }
  use {
    "ur4ltz/surround.nvim", -- Automatically surround quotes, parens, braces, etc.
    config = function()
      require("surround").setup {
        mappings_style = "surround"
      }
    end
  }
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use {
    "folke/which-key.nvim", -- Popup window with key binding suggestions
    config = function () require("user.whichkey") end,
  }
  use {
    "ellisonleao/glow.nvim", -- Markdown preview
    config = function()
      vim.g.glow_border = "rounded"
    end,
  }
  use {
    "folke/todo-comments.nvim", -- Manage todos, fix, hack, etc.
    config = function() require("todo-comments").setup() end,
  }
  use "moll/vim-bbye" -- Delete buffers without closing windows
  use {
    "kosayoda/nvim-lightbulb", -- Displays lightbulb in sign column when code actions are available
    config = function () require("user.lightbulb") end,
  }

  -- Colorschemes
  use {
    "jllacuna/jellybeans-nvim", -- My fork of the jellbeans colorscheme
    requires = {{ "rktjmp/lush.nvim" }}
  }
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  -- use "mhartington/oceanic-next" -- This is also a nice colorscheme. Just don't like that function names don't pop as much

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp",                                 -- The completion plugin
    config = function () require("user.cmp") end,
  }
  use "hrsh7th/cmp-buffer"                              -- Buffer completions
  use "hrsh7th/cmp-path"                                -- Path completions
  use {
    "hrsh7th/cmp-cmdline",                              -- Command line completions
    commit = "e1ba818534a357b77494597469c85030c7233c16" -- https://github.com/hrsh7th/cmp-cmdline/issues/71
  }
  use "hrsh7th/cmp-nvim-lua"                            -- Neovim Lua runtime API
  use "saadparwaiz1/cmp_luasnip"                        -- Snippet completions
  use "hrsh7th/cmp-nvim-lsp"                            -- LSP completions
  use "hrsh7th/cmp-nvim-lsp-signature-help"             -- Signature help

  -- snippets
  use "L3MON4D3/LuaSnip"             -- Snippet engine
  use "rafamadriz/friendly-snippets" -- Snippet collection

  -- LSP
  use {
    "williamboman/nvim-lsp-installer", -- simple to use language server installer
    requires = {{ "neovim/nvim-lspconfig" }},
    config = function () require("user.lsp") end,
  }
  use "jose-elias-alvarez/typescript.nvim" -- LSP intgration for tsserver (javascript, typescript)
  use {
    "SmiteshP/nvim-navic", -- Display code context in status line
    config = function () require("user.navic") end,
  }

  -- Use this if we want to configure LSP in JSON or if we're trying to import existing COC/VS Code LSP settings
  -- use "tamago324/nlsp-settings.nvim" -- language server settings defined in JSON

  -- Use this if we find a program we want to use for linting/formatting, etc. that isn't provided via LSP
  -- See https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md for a list of supported sources
  -- use "jose-elias-alvarez/null-ls.nvim" -- Extends LSP to support linters and formatters that don't operate as an LSP server like prettier

  -- Telescope
  use {
    'nvim-telescope/telescope-fzf-native.nvim', -- Fast fuzzy finder for telescope
    run = 'make',
  }
  use {
    "nvim-telescope/telescope.nvim", -- Fuzzy finder popup
    config = function () require("user.telescope") end,
  }
  use {
    "sudormrfbin/cheatsheet.nvim", -- Displays a cheatsheet of commands, keymaps, nerd font icons, etc. in telescope
    config = function () require("user.cheatsheet") end,
  }

  -- Treesitter
  use {
    "windwp/nvim-ts-autotag",                            -- Complete SGML (XML, HTML, etc.) tags
    requires = {{ "nvim-treesitter/nvim-treesitter" }},  -- Syntax parsing for better code highlights, etc.
    config = function () require("user.treesitter") end,
  }
  use "JoosepAlviste/nvim-ts-context-commentstring" -- Changes format of comments based on location within the file. Useful for JSX and svelte
  use "nvim-treesitter/playground" -- Allows you to inspect treesitter syntax trees

  -- Git
  use {
    "lewis6991/gitsigns.nvim", -- Displays git change indicators in the sign column and allows you to perform git operations inline
    config = function () require("user.gitsigns") end,
  }

  -- Coffeescript
  use "kchmck/vim-coffee-script" -- Support for coffeescript syntax highlighting, etc.

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
