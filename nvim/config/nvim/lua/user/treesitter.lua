local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify "nvim-treesitter not found"
  return
end

-- Store treesitter parsers in a separate folder so that we can cache them when building docker
vim.opt.runtimepath:append( "/usr/local/lib/treesitter_parsers")

configs.setup {
  -- Tell plugin where we put the parsers
  parser_install_dir = "/usr/local/lib/treesitter_parsers",

  ensure_installed = {
    "bash", "c_sharp", "cmake", "comment", "css", "dart", "dockerfile", "eex",
    "elixir", "erlang", "go", "gomod", "gowork", "graphql", "haskell", "html",
    "http", "java", "javascript", "jsdoc", "json", "kotlin", "lua", "make",
    "ninja", "nix", "perl", "php", "proto", "python", "r", "regex", "ruby",
    "rust", "scala", "scss", "svelte", "swift", "toml", "typescript", "vim",
    "vue", "yaml"
  }, -- one of "all" (not recommended), or a list of languages

  -- WARNING: Leave sync_install to true so that Docker will compile the parsers into the image on build
  sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)

  -- ignore_install = {}, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    -- disable = {}, -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    -- disable = { "yaml" }
  },
  incremental_selection = {
    enable = true,
    -- keymaps = {
    --   init_selection = "gnn",
    --   node_incremental = "grn",
    --   scope_incremental = "grc",
    --   node_decremental = "grm",
    -- },
  },
  autotag = {
    enable = true,
  },
  playground = {
    enable = true,
    -- disable = {},
    updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
}

local comment_status_ok, commentstring = pcall(require, "ts_context_commentstring")
if not comment_status_ok then
  vim.notify "nvim-ts-context-commentstring not found"
  return
end

commentstring.setup {}
