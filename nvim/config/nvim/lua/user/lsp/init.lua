local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
  vim.notify "mason not found"
  return
end

mason.setup {
  -- Store mason installs in a separate folder so that we can cache them when building docker
  install_root_dir = "/usr/local/lib/mason",
  ui ={
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = ""
    }
  }
}

require "user.lsp.configs"
require("user.lsp.handlers").setup()
