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

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd [[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]]

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
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim"    -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim"  -- Useful lua functions used by lots of plugins
  use "RRethy/vim-illuminate"  -- highlight other instances of the word under cursor
  use "b0o/schemastore.nvim"   -- JSON schemas from schemastore.org
  use {
    "windwp/nvim-autopairs",   -- Autopairs, integrates with both cmp and treesitter
    config = function () require("user.autopairs") end,
  }
  use {
    "numToStr/Comment.nvim",   -- Easily comment stuff
    config = function () require("user.comment") end,
  }
  use "godlygeek/tabular"
  use "windwp/nvim-ts-autotag"
  use {
    "kyazdani42/nvim-tree.lua",
    config = function () require("user.tree") end,
  }
  use {
    "nvim-lualine/lualine.nvim", -- Status line
    config = function () require("user.lualine") end,
  }
  use {
    "kdheepak/tabline.nvim",
    config = function () require("user.tabline") end,
  }
  -- CONTINUE HERE
  -- TODO: Finish YT series for additional tips
  -- TODO: Clean up code
  -- TODO: Tag 1.0 release
  -- use "moll/vim-bbye"
  -- use "lewis6991/impatient.nvim" -- Not sure how this will work with docker. May not speed anything up since starting the container seems to be the slow part
  use {
    "ur4ltz/surround.nvim",
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
    config = function() require("todo-comments").setup() end
  }

  -- Colorschemes
  use {
    "kyazdani42/nvim-web-devicons",
    config = function () require("user.devicons") end,
  }
  use {
    "jllacuna/jellybeans-nvim",
    requires = {{"rktjmp/lush.nvim"}}
  }
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  -- use "mhartington/oceanic-next"

  -- cmp plugins
  use {
    "hrsh7th/nvim-cmp",                     -- The completion plugin
    config = function () require("user.cmp") end,
  }
  use "hrsh7th/cmp-buffer"                  -- buffer completions
  use "hrsh7th/cmp-path"                    -- path completions
  use "hrsh7th/cmp-cmdline"                 -- cmdline completions
  use "hrsh7th/cmp-nvim-lua"                -- Neovim Lua runtime API
  use "saadparwaiz1/cmp_luasnip"            -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"                -- lsp completions
  use "hrsh7th/cmp-nvim-lsp-signature-help" -- signature help

  -- snippets
  use "L3MON4D3/LuaSnip"             -- snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  -- simple to use language server installer
  use {
    "williamboman/nvim-lsp-installer",
    requires = {{"neovim/nvim-lspconfig" }},
    config = function () require("user.lsp") end,
  }
  use "jose-elias-alvarez/typescript.nvim" -- tsserver lsp intgration
  use {
    "SmiteshP/nvim-navic", -- Display code context in status line
    config = function () require("user.navic") end,
  }
  -- use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  -- use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

  -- Telescope
  use {
    'nvim-telescope/telescope-fzf-native.nvim', -- Fase fuzzy finder for telescope
    run = 'make',
  }
  use {
    "nvim-telescope/telescope.nvim",
    config = function () require("user.telescope") end,
  }
  use {
    "sudormrfbin/cheatsheet.nvim", -- Displays a cheatsheet of commands, keymaps, nerd font icons, etc. in telescope
    config = function () require("user.cheatsheet") end,
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function () require("user.treesitter") end,
  }
  use "JoosepAlviste/nvim-ts-context-commentstring" -- Changes format of comments based on location within the file. Useful for JSX and svelte
  use "nvim-treesitter/playground"

  -- Git
  use {
    "lewis6991/gitsigns.nvim", -- Displays git change indicators in the sign column
    config = function () require("user.gitsigns") end,
  }

  -- Coffeescript
  use "kchmck/vim-coffee-script"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
