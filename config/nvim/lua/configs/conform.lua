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
      -- Memaksa menggunakan prettier dari Mason untuk menghindari error modul lokal proyek yang rusak, dengan fallback
      command = function()
        local mason_path = vim.fn.stdpath("data") .. "/mason/bin/prettier"
        if vim.fn.executable(mason_path) == 1 then
          return mason_path
        end
        return "prettier"
      end,
    },
  },
}

return options
