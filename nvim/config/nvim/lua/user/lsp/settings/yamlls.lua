local opts = {
  settings = {
    schemaStore = {
      -- You must disable built-in schemaStore support if you want to use
      -- b0o/schemastore.nvim plugin and its advanced options like `ignore`.
      enable = false,
      -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      url = "",
    },
    yaml = {
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}

return opts
