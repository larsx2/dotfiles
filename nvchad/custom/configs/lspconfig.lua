local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "yamlls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- 
--
-- lspconfig.graphql-lsp.setup
local util = require("lspconfig/util")
lspconfig.graphql.setup {
  cmd = { "graphql-lsp", "server", "-m", "stream" },
  filetypes = { "graphql", "typescriptreact", "javascriptreact" },
  root_dir = function(fname)
    return util.root_pattern('.git')(fname) or util.path.dirname(fname)
  end,
}

lspconfig.terraformls.setup{}
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})
