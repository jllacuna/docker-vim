local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  vim.notify "nvim-tree not found"
  return
end

-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
nvim_tree.setup {
  renderer = {
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          deleted = "",
          untracked = "U",
          ignored = "◌",
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
  },
  disable_netrw = true,
  hijack_netrw = false, -- default
  open_on_setup = false, -- default
  ignore_ft_on_setup = { -- not relevant if open_on_setup = false
    -- "startify",
    -- "dashboard",
    -- "alpha",
  },
  open_on_tab = false,
  hijack_cursor = true, -- default false, keeps cursor on first letter of filename
  update_cwd = false, -- default
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {}, -- default
  },
  system_open = {
    cmd = "", -- default
    args = {}, -- default
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 1000, -- default 400 ms
  },
  view = {
    width = 30, -- default
    height = 30, -- default
    adaptive_size = true,
    hide_root_folder = true,
    side = "left",
    mappings = {
      custom_only = false,
      list = {
        { key = { "<CR>", "o" },  action = "edit" },              -- default
        { key = "<Tab>",          action = "preview" },           -- default
        { key = "f",              action = "live_filter" },       -- default
        { key = "F",              action = "clear_live_filter" }, -- default
        { key = "E",              action = "expand_all" },        -- default
        { key = "W",              action = "collapse_all" },      -- default
        { key = "<C-k>",          action = "toggle_file_info" },  -- default
        { key = "g?",             action = "toggle_help" },       -- default
        { key = "y",              action = "copy_name" },         -- default
        { key = "Y",              action = "copy_path" },         -- default
        { key = "P",              action = "parent_node" },       -- default
        { key = "R",              action = "refresh" },           -- default
        { key = "h",              action = "close_node" },        -- default is <BS>
        { key = "v",              action = "vsplit" },            -- default is <C-v>
        { key = "s",              action = "split" },             -- default is <C-x>, s is default for system_open
        { key = "t",              action = "tabnew" },            -- default is <C-t>
        { key = "<C-x>",          action = "cut" },               -- default is x, <C-x> is default for split
        { key = "x",              action = "" },                  -- default is cut
        { key = "<C-c>",          action = "copy" },              -- default is c
        { key = "c",              action = "" },                  -- default is copy
        { key = "<C-v>",          action = "paste" },             -- default is p
        { key = "p",              action = "" },                  -- default is paste
        { key = "a",              action = "create" },            -- default
        { key = "r",              action = "rename" },            -- default
        { key = "<C-d>",          action = "remove" },            -- default is d, will prompt for confirmation
        { key = "d",              action = "" },                  -- default is remove
        { key = "gy",             action = "" },                  -- default is copy_absolute_path
        { key = "D",              action = "" },                  -- default is trash
        { key = "<C-]>",          action = "" },                  -- default is cd
        { key = "-",              action = "" },                  -- default is dir_up
        { key = "<2-LeftMouse>",  action = "" },                  -- disable mouse clicks, default is edit
        { key = "<2-RightMouse>", action = "" },                  -- disable mouse clicks, default is cd
      },
    },
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  actions = {
    change_dir = {
      enable = false,
    },
    open_file = {
      quit_on_open = false,
      window_picker = {
        enable = false,
      },
    },
  },
}
