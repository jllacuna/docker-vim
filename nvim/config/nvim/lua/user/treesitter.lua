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
    "astro", "bash", "c", "c_sharp", "cmake", "comment", "cpp", "css", "dart",
    "dockerfile", "eex", "elixir", "elm", "embedded_template", "erlang",
    "fish", "glimmer", "go", "gomod", "gowork", "graphql", "hack", "haskell",
    "hcl", "heex", "help", "html", "http", "java", "javascript", "jsdoc",
    "json", "jsonc", "julia", "kotlin", "lalrpop", "latex", "lua", "make",
    "ninja", "ocaml", "ocamllex", "perl", "php", "pioasm", "proto", "pug",
    "python", "ql", "r", "regex", "ruby", "rust", "scala", "scss", "sparql",
    "surface", "svelte", "swift", "todotxt", "toml", "turtle", "typescript",
    "v", "vim", "vue", "yaml"
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
  context_commentstring = {
    enable = true,
    enable_autocmd = false, -- For Comment.nvim
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
