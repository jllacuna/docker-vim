local status_ok, tabline = pcall(require, "tabline")
if not status_ok then
  vim.notify "tabline not found"
  return
end

tabline.setup {
  options = {
    show_filename_only = true,
    modified_italic = false,
  },
}
