local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "eslint_d", "lsp_fallback" },
    typescript = { "eslint_d", "lsp_fallback" },
    javascriptreact = { "eslint_d", "lsp_fallback" },
    typescriptreact = { "eslint_d", "lsp_fallback" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
    async = false,
  },
}

return options
