local opts = {
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        }
      }
    }
  }
}

return opts
