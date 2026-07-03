local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 1000,
    lsp_fallback = true,
  },

  formatters = {
    prettier = {
      -- Memaksa menggunakan prettier dari Mason untuk menghindari error modul lokal proyek yang rusak
      command = vim.fn.stdpath("data") .. "/mason/bin/prettier",
    },
  },
}

return options
