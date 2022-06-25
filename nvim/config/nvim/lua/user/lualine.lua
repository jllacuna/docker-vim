local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  vim.notify "lualine not found"
  return
end

local navic_status_ok, navic = pcall(require, "nvim-navic")
if not navic_status_ok then
  vim.notify "nvim-navic not found"
  return
end

lualine.setup {
  sections = {
    lualine_c = {
      "filename",
      { navic.get_location, cond = navic.is_available },
    },
  },
}
