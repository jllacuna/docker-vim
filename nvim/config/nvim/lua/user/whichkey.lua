local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  vim.notify "which-key not found"
  return
end

which_key.setup {
  triggers_blacklist = {
    n = {
      "o", "O", -- Messes with our "oo" and "OO" keymaps to add a line without going into insert mode
    },
  },
}
