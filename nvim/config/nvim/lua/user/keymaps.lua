local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Merge options. WARNING: Overwrites t1
local function merge(t1, t2)
  for k,v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        merge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   "n": normal_mode
--   "i": insert_mode
--   "v": visual_mode
--   "x": visual_block_mode
--   "t": term_mode
--   "c": command_mode
--   "": normal_mode, visual_mode, select_mode, operater_pending_mode
--   "!": insert_mode, command_mode

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", merge({ desc = 'File explorer' }, opts))

-- Disable arrow keys
keymap("", "<Up>", "", opts)
keymap("!", "<Up>", "", opts)
keymap("", "<Down>", "", opts)
keymap("!", "<Down>", "", opts)
keymap("", "<Left>", "", opts)
keymap("!", "<Left>", "", opts)
keymap("", "<Right>", "", opts)
keymap("!", "<Right>", "", opts)

-- Resize with arrows
keymap("n", "<Up>", ":resize -2<CR>", opts)
keymap("n", "<Down>", ":resize +2<CR>", opts)
keymap("n", "<Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- Keep original copy string when pasting
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope --
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", merge({ desc = 'Find files' }, opts))
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", merge({ desc = 'Search in files' }, opts))
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", merge({ desc = 'Find buffers' }, opts))
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", merge({ desc = 'Find help tags' }, opts))
keymap("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", merge({ desc = 'Find diagnostics' }, opts))

-- Cheatsheet --
keymap("n", "<leader>cs", "<cmd>Cheatsheet<cr>", opts)

-- Treesitter Playground --
keymap("n", "<leader>s", "<cmd>TSHighlightCapturesUnderCursor<cr>", opts)
keymap("n", "<leader>p", "<cmd>TSPlaygroundToggle<cr>", opts)

-- Glow (Markdown Preview) --
keymap("n", "<leader>m", "<cmd>Glow<cr>", opts)

-- Todo Comments --
keymap("n", "<leader>t", "<cmd>TodoQuickFix<cr>", opts)
keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", opts)

-- Bbye --
keymap("n", "<leader>bd", "<cmd>Bdelete<cr>", opts)

-- Toggle line numbers
keymap("n", "<leader>l", ":set nonumber!<CR>", opts)

-- Add lines above and below
keymap("n", "OO", "O<ESC>", opts)
keymap("n", "oo", "o<ESC>", opts)

-- Open new tab
keymap("n", "tt", ":tabnew<CR>", opts)

-- Go to next and previous tab
keymap("n", "tj", ":tabp<CR>", opts)
keymap("n", "tk", ":tabn<CR>", opts)

-- Reformat
keymap("n", "fff", "gg=G", opts)

-- Convert tabs to spaces and remove extra whitespace
keymap("n", "sss", ':retab<CR>:%s/\\s\\+$//c<CR>', opts)

-- Search for TODOs
keymap("n", "td", ":vimgrep TODO **/*<CR>:cw<CR>", opts)

-- Grep word under cursor (not working)
-- keymap("n", "K", ':grep! "\\b<C-R><C-W>\\b"<CR>:cw<CR>', opts)
