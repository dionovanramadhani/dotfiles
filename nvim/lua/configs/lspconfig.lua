require("nvchad.configs.lspconfig").defaults()

vim.diagnostic.config({
  update_in_insert = true,
})

local root_pattern = require("lspconfig.util").root_pattern

vim.lsp.config("emmet_language_server", {
  filetypes = {
    "html",
    "css",
    "scss",
    "javascriptreact",
    "typescriptreact",
  },
  root_dir = function(buf)
    local fname = type(buf) == "number" and vim.api.nvim_buf_get_name(buf) or buf
    return vim.fs.dirname(fname) or vim.uv.cwd()
  end,
  init_options = {
    showExpandedAbbreviation = "always",
    showAbbreviationSuggestions = true,
    showSuggestionsAsSnippets = true,
  },
})

vim.lsp.config("eslint", {
  root_dir = root_pattern(
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts"
  ),
})

local servers = { "html", "cssls", "ts_ls", "tailwindcss", "emmet_language_server", "eslint", "prismals" }
vim.lsp.enable(servers)
