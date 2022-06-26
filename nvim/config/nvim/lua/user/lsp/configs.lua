local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  vim.notify "nvim-lsp-installer not found"
  return
end

local lsp_status_ok, lspconfig = pcall(require, "lspconfig")
if not lsp_status_ok then
  vim.notify "lspconfig not found"
  return
end

-- TODO:
-- go
-- ruby
-- markdown
-- swift
-- python

local servers = {
  "jsonls",
  "sumneko_lua",
  "cssls",
  "html",
  "tsserver",
  "yamlls",
  "dockerls",
  "svelte",
  "ember",
  "gopls",
}

lsp_installer.setup {
  ensure_installed = servers
}

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
  end

  if server == "tsserver" then
    require("typescript").setup({
      disable_commands = false, -- prevent the plugin from creating vim commands
      debug = false, -- enable debug logging for commands
      server = opts,
    })
  else
    lspconfig[server].setup(opts)
  end
end
