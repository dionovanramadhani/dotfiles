-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",

  changed_themes = {
    gruvbox = {
      base_30 = {
        black = "#1d2021",
        darker_black = "#181a1b",
        black2 = "#222526",
      },
      base_16 = {
        base00 = "#1d2021",
      },
    },
  },

  hl_override = {
    LspReferenceText = { bg = "#3c3836", underline = true },
    LspReferenceRead = { bg = "#3c3836", underline = true },
    LspReferenceWrite = { bg = "#3c3836", underline = true, bold = true },
    IblScopeChar = { fg = "#ffffff" },
  },
}

M.term = {
  float = {
    row = 0.1,
    col = 0.075,
    width = 0.85,
    height = 0.8,
  },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "______ _____ ____ ___ ___",
    "`  _  V  _  V  _ \\|  V  ´",
    "| | | | | | | | | |     |",
    "| | | | | | | | | | . . |",
    "| |/ / \\ \\| | |/ /\\ |V| |",
    "|   /   \\__/ \\__/  \\| | |",
    "|  /                ' | |",
    "| /     E M A C S     \\ |",
    "´´                     ``",
    "                         ",
    "                         ",
  },
}

M.ui = {
  tabufline = {
    enabled = false,
  },
}

return M
