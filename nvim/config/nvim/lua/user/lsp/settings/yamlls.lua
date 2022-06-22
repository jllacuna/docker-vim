local schemas = {
  ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
  ["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
}

local opts = {
  settings = {
    yaml = {
      schemas = schemas,
    },
  },
}

return opts
