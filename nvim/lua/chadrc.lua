-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "gruvbox",

	hl_override = {
		LspReferenceText = { bg = "#3c3836", underline = true },
		LspReferenceRead = { bg = "#3c3836", underline = true },
		LspReferenceWrite = { bg = "#3c3836", underline = true, bold = true },
		IblScopeChar = { fg = "#ffffffff" },
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
    "▄▀█ █▀▄▀█ ██▄ ▄▀█ ▀█▀ █ █ ▄▀▀ ▄▀▀▄ █▀▄ █▀▀",
    "█▀█ █ ▀ █ █▄█ █▀█  █  █▄█ ▀▄▄ ▀▄▄▀ █▄▀ █▄▄",
    "",
    "",
    "",
  },
}

return M
