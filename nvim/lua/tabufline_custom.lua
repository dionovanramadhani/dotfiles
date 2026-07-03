local M = {}

M.setup = function()
  local ok, utils = pcall(require, "nvchad.tabufline.utils")
  if not ok then return end

  -- Load tbline cache if it exists, since we disabled nvchad's default tabufline
  local function load_tbline_hl()
    if vim.g.base46_cache then
      pcall(dofile, vim.g.base46_cache .. "tbline")
    end
  end

  load_tbline_hl()

  -- Reload tbline cache whenever colorscheme changes to prevent highlights being cleared
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = load_tbline_hl,
  })

  local api = vim.api
  local get_opt = api.nvim_get_option_value
  local strep = string.rep
  local cur_buf = api.nvim_get_current_buf
  local buf_name = api.nvim_buf_get_name
  local get_hl = api.nvim_get_hl

  local btn = utils.btn
  local txt = utils.txt

  local function filename(str)
    return str:match "([^/\\]+)[/\\]*$"
  end

  local function new_hl(group1, group2)
    local fg = get_hl(0, { name = group1, link = false }).fg
    local bg = get_hl(0, { name = "Tb" .. group2, link = false }).bg
    api.nvim_set_hl(0, group1 .. group2, { fg = fg, bg = bg })
    return "%#" .. group1 .. group2 .. "#"
  end

  local function gen_unique_name(name, index)
    for i2, nr2 in ipairs(vim.t.bufs) do
      local filepath = filename(buf_name(nr2))
      if index ~= i2 and filepath == name then
        return vim.fn.fnamemodify(buf_name(vim.t.bufs[index]), ":h:t") .. "/" .. name
      end
    end
  end

  -- Custom highlight generator
  local function get_custom_buf_hl(suffix, is_curbuf, color_fg)
    local base_group = "TbBufO" .. (is_curbuf and "n" or "ff")
    local hl_name = base_group .. suffix
    local bg_color = get_hl(0, { name = base_group, link = false }).bg
    api.nvim_set_hl(0, hl_name, { fg = color_fg, bg = bg_color })
    return "BufO" .. (is_curbuf and "n" or "ff") .. suffix
  end

  utils.style_buf = function(nr, i, w)
    -- add fileicon + name
    local icon = "󰈚 "
    local is_curbuf = cur_buf() == nr
    local tbHlName = "BufO" .. (is_curbuf and "n" or "ff")
    local icon_hl = new_hl("DevIconDefault", tbHlName)

    local name = filename(buf_name(nr))
    name = name and (gen_unique_name(name, i) or name) or " No Name "

    if name ~= " No Name " then
      local devicon, devicon_hl = require("nvim-web-devicons").get_icon(name)
      if devicon then
        icon = " " .. devicon .. " "
        icon_hl = new_hl(devicon_hl, tbHlName)
      end
    end

    -- Determine diagnostics & git status
    local has_error = false
    local ok_diag, diags = pcall(vim.diagnostic.get, nr, { severity = vim.diagnostic.severity.ERROR })
    if ok_diag and diags and #diags > 0 then
      has_error = true
    end

    local is_modified = false
    local is_untracked = false

    -- Check gitsigns cache first for untracked and modified status
    local ok_cache, cache_mod = pcall(require, "gitsigns.cache")
    if ok_cache and cache_mod and cache_mod.cache then
      local bcache = cache_mod.cache[nr]
      if bcache then
        if bcache.git_obj and bcache.git_obj.object_name == nil then
          is_untracked = true
        elseif bcache.hunks and #bcache.hunks > 0 then
          is_modified = true
        end
      end
    end

    -- Fallback to gitsigns_status_dict if cache is not available
    local git_status = vim.b[nr].gitsigns_status_dict
    if git_status and not is_untracked and not is_modified then
      if (git_status.changed and git_status.changed > 0) or (git_status.removed and git_status.removed > 0) then
        is_modified = true
      elseif git_status.added and git_status.added > 0 then
        is_untracked = true
      end
    end

    local text_hl_name = tbHlName

    if has_error then
      local err_fg = (get_hl(0, { name = "DiagnosticError", link = false }) or {}).fg or 16468276 -- default red
      text_hl_name = get_custom_buf_hl("Error", is_curbuf, err_fg)
    elseif is_untracked then
      local add_fg = (get_hl(0, { name = "GitSignsAdd", link = false }) or {}).fg or 12106534 -- default green
      text_hl_name = get_custom_buf_hl("GitAdd", is_curbuf, add_fg)
    elseif is_modified then
      local mod_fg = (get_hl(0, { name = "GitSignsChange", link = false }) or {}).fg or 16432431 -- default yellow
      text_hl_name = get_custom_buf_hl("GitMod", is_curbuf, mod_fg)
    end

    -- padding around bufname; 15= maxnamelen + 2 icon & space + 2 close icon
    local pad = math.floor((w - #name - 5) / 2)
    pad = pad <= 0 and 1 or pad

    local maxname_len = w - 5
    name = string.sub(name, 1, maxname_len - 2) .. (#name > maxname_len and ".." or "")
    name = txt(name, text_hl_name)

    name = strep(" ", pad - 1) .. (icon_hl .. icon .. name) .. strep(" ", pad - 1)

    local close_btn = btn(" 󰅖 ", nil, "KillBuf", nr)
    name = btn(name, nil, "GoToBuf", nr)

    -- modified bufs icon or close icon
    local mod = get_opt("mod", { buf = nr })
    local cur_mod = get_opt("mod", { buf = 0 })

    -- color close btn for focused / hidden buffers
    if is_curbuf then
      close_btn = cur_mod and txt("  ", "BufOnModified") or txt(close_btn, "BufOnClose")
    else
      close_btn = mod and txt("  ", "BufOffModified") or txt(close_btn, "BufOffClose")
    end

    name = txt(name .. close_btn, tbHlName)

    return name
  end

  -- Auto redraw tabline on diagnostics or git change
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      vim.cmd("redrawtabline")
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    callback = function()
      vim.cmd("redrawtabline")
    end,
  })

  -- Force reload tabline module to apply the override
  package.loaded["nvchad.tabufline.modules"] = nil
end

return M
