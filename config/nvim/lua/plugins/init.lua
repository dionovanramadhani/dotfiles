return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = false,
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "prettier",

        -- LSPs
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
        "tailwindcss-language-server",
        "emmet-language-server",
        "eslint-lsp",
        "prisma-language-server",
      },
    },
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript", "tsx", "prisma"
      },
    },
  },

  {
    "mg979/vim-visual-multi",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
        ["Select All"] = "<C-S-l>",
        ["Add Cursor Up"] = "<C-S-A-Up>",
        ["Add Cursor Down"] = "<C-S-A-Down>",
      }
    end,
    config = function()
      -- Map untuk mode Insert dan Select agar meneruskan ke mapping Normal/Visual dari plugin.
      -- Kita menggunakan remap = true agar Neovim memicu mapping Ctrl+d dan Ctrl+Shift+l milik vim-visual-multi.
      vim.keymap.set("i", "<C-d>", "<Esc><C-d>", { remap = true, silent = true, desc = "VM: Find Under (Insert)" })
      vim.keymap.set("s", "<C-d>", function()
        -- Menggunakan feedkeys secara berurutan: switch mode dari Select ke Visual dengan <C-g> (synchronous),
        -- lalu memicu C-d dalam mode Visual secara rekursif (m) agar terbaca oleh plugin.
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "nx", false)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-d>", true, false, true), "m", false)
      end, { silent = true, desc = "VM: Find Under (Select)" })

      vim.keymap.set("i", "<C-S-l>", "<Esc><C-S-l>", { remap = true, silent = true, desc = "VM: Select All (Insert)" })
      vim.keymap.set("s", "<C-S-l>", function()
        -- Sama seperti di atas untuk Ctrl+Shift+l
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, false, true), "nx", false)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-S-l>", true, false, true), "m", false)
      end, { silent = true, desc = "VM: Select All (Select)" })

      -- Map Ctrl+Shift+Alt+Up/Down (dan variasinya) untuk menambah cursor
      local keys_up = { "<C-S-A-Up>", "<C-A-S-Up>", "<C-S-M-Up>", "<C-M-S-Up>" }
      local keys_down = { "<C-S-A-Down>", "<C-A-S-Down>", "<C-S-M-Down>", "<C-M-S-Down>" }

      for _, key in ipairs(keys_up) do
        vim.keymap.set("n", key, "<Plug>(VM-Add-Cursor-Up)", { remap = true, silent = true, desc = "VM: Add Cursor Up" })
        vim.keymap.set("x", key, "<Plug>(VM-Add-Cursor-Up)", { remap = true, silent = true, desc = "VM: Add Cursor Up (Visual)" })
        vim.keymap.set("s", key, "<C-g><Plug>(VM-Add-Cursor-Up)", { remap = true, silent = true, desc = "VM: Add Cursor Up (Select)" })
        vim.keymap.set("i", key, "<Esc><Plug>(VM-Add-Cursor-Up)", { remap = true, silent = true, desc = "VM: Add Cursor Up (Insert)" })
      end

      for _, key in ipairs(keys_down) do
        vim.keymap.set("n", key, "<Plug>(VM-Add-Cursor-Down)", { remap = true, silent = true, desc = "VM: Add Cursor Down" })
        vim.keymap.set("x", key, "<Plug>(VM-Add-Cursor-Down)", { remap = true, silent = true, desc = "VM: Add Cursor Down (Visual)" })
        vim.keymap.set("s", key, "<C-g><Plug>(VM-Add-Cursor-Down)", { remap = true, silent = true, desc = "VM: Add Cursor Down (Select)" })
        vim.keymap.set("i", key, "<Esc><Plug>(VM-Add-Cursor-Down)", { remap = true, silent = true, desc = "VM: Add Cursor Down (Insert)" })
      end
    end,
    lazy = false,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {
        plugins = {
          presets = {
            windows = false,
          },
        },
      }
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require("cmp")
      local conf = require("nvchad.configs.cmp")

      conf.mapping["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" })

      conf.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
        if require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" })

      conf.mapping["<Down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "s" })

      conf.mapping["<Up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" })

      conf.mapping["<CR>"] = cmp.mapping(function(fallback)
        fallback()
      end)

      -- Filter out Text kind from nvim_lsp source
      for _, source in ipairs(conf.sources or {}) do
        if source.name == "nvim_lsp" then
          source.entry_filter = function(entry, ctx)
            return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
          end
        end
      end

      -- Remove buffer source (plain text from current files)
      if conf.sources then
        local filtered_sources = {}
        for _, source in ipairs(conf.sources) do
          if source.name ~= "buffer" then
            table.insert(filtered_sources, source)
          end
        end
        conf.sources = filtered_sources
      end

      -- Disable completion inside comments and strings
      conf.enabled = function()
        local context = require("cmp.config.context")
        -- Keep command mode completion enabled
        if vim.api.nvim_get_mode().mode == "c" then
          return true
        else
          return not context.in_treesitter_capture("comment")
            and not context.in_syntax_group("Comment")
            and not context.in_treesitter_capture("string")
            and not context.in_syntax_group("String")
        end
      end

      return conf
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep:│,foldclose:]]

      require("ufo").setup(opts)

      -- Keymaps for folding (zR: open all, zM: close all, za: toggle under cursor)
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
      vim.keymap.set("n", "za", "za", { desc = "Toggle fold" })
    end,
  },

  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    opts = {
      bar = {
        enable = false,
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 500,           -- Delay sebelum memunculkan info commit (ms)
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    opts = {},
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    opts = {
      kind = "vsplit",
      integrations = {
        diffview = true,
      },
    },
  },

  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    keys = {
      {
        "<leader>gg",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph Draw",
      },
    },
    opts = {
      symbols = {
        merge_commit = "",
        commit = "",
        merge_commit_end = "",
        commit_end = "",
        GVER = "│",
        GHOR = "─",
        GCLD = "┌",
        GCRD = "┐",
        GCLU = "└",
        GCRU = "┘",
        GLUD = "┘",
        GLUR = "┘",
        GRLD = "┌",
        GRRU = "┐",
        RGCL = "┌",
        RGCR = "┐",
        RGIL = "│",
        RGIR = "│",
        RGLU = "└",
        RGRU = "┘",
        GLRD = "┌",
        GLRU = "┘",
        SUB = "│",
        ROUTE_HOR = "─",
        ROUTE_VER = "│",
        ROUTE_CROSS = "┼",
      },
      format = {
        timestamp = "%Y-%m-%d %H:%M:%S",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        on_select_commit = function(commit)
          vim.notify("Opening diff for commit " .. commit.hash)
          vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
        end,
        on_select_range_commit = function(from, to)
          vim.notify("Opening diff from " .. from.hash .. " to " .. to.hash)
          vim.cmd("DiffviewOpen " .. from.hash .. ".." .. to.hash)
        end,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
      renderer = {
        highlight_git = true,
        highlight_diagnostics = "all",
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local conf = require("nvchad.configs.telescope")
      conf.defaults.mappings.i = conf.defaults.mappings.i or {}
      conf.defaults.mappings.i["<C-Backspace>"] = { "<C-w>", type = "command" }
      return conf
    end,
  },

  {
    "e-sigs/winbuf.nvim",
    event = "VeryLazy",
    config = function()
      require("winbuf").setup({
        style = "slant",
      })

      -- Custom winbuf.render override to support Git status (untracked, modified)
      -- and diagnostics colors on tab filenames.
      local winbuf_render = require("winbuf.render")
      local tracker = require("winbuf.tracker")
      local winbuf = require("winbuf")
      local api = vim.api
      local get_hl = api.nvim_get_hl

      local function get_diagnostics(buf)
        if not api.nvim_buf_is_valid(buf) then
          return { error = 0, warning = 0 }
        end
        local counts = { error = 0, warning = 0 }
        for _, d in ipairs(vim.diagnostic.get(buf)) do
          if d.severity == vim.diagnostic.severity.ERROR then
            counts.error = counts.error + 1
          elseif d.severity == vim.diagnostic.severity.WARN then
            counts.warning = counts.warning + 1
          end
        end
        return counts
      end

      local function truncate(name, max_len)
        if not max_len or max_len <= 0 then return name end
        if vim.fn.strcharlen(name) <= max_len then return name end
        if max_len <= 1 then return vim.fn.strcharpart(name, 0, max_len) end
        return vim.fn.strcharpart(name, 0, max_len - 1) .. "…"
      end

      local function escape_pct(s)
        return s:gsub("%%", "%%%%")
      end

      local function pad(n)
        return n > 0 and string.rep(" ", n) or ""
      end

      local function get_custom_hl(base_group, suffix, color_fg)
        local hl_name = base_group .. suffix
        local bg_color = get_hl(0, { name = base_group, link = false }).bg
        api.nvim_set_hl(0, hl_name, { fg = color_fg, bg = bg_color })
        return hl_name
      end

      local function apply_custom_highlights()
        local err_fg = (get_hl(0, { name = "DiagnosticError", link = false }) or {}).fg or 16468276
        local warn_fg = (get_hl(0, { name = "DiagnosticWarn", link = false }) or {}).fg or 16679219
        local add_fg = (get_hl(0, { name = "GitSignsAdd", link = false }) or {}).fg or 12106534
        local mod_fg = (get_hl(0, { name = "GitSignsChange", link = false }) or {}).fg or 16432431

        get_custom_hl("WinBufActive", "Error", err_fg)
        get_custom_hl("WinBufActive", "Warn", warn_fg)
        get_custom_hl("WinBufActive", "GitAdd", add_fg)
        get_custom_hl("WinBufActive", "GitMod", mod_fg)

        get_custom_hl("WinBufInactive", "Error", err_fg)
        get_custom_hl("WinBufInactive", "Warn", warn_fg)
        get_custom_hl("WinBufInactive", "GitAdd", add_fg)
        get_custom_hl("WinBufInactive", "GitMod", mod_fg)

        -- Statusline breadcrumbs highlights (dimmed, italic Comment foreground)
        local st_bg = (get_hl(0, { name = "StatusLine", link = false }) or {}).bg
        local comment_fg = (get_hl(0, { name = "Comment", link = false }) or {}).fg or 9601908
        api.nvim_set_hl(0, "St_breadcrumbs", { fg = comment_fg, bg = st_bg, italic = true })
      end

      apply_custom_highlights()

      api.nvim_create_autocmd("ColorScheme", {
        callback = apply_custom_highlights,
      })

      winbuf_render.render = function(win)
        local config = winbuf.config
        local cur_buf = api.nvim_win_get_buf(win)
        local bufs = tracker.get_win_bufs(win)

        bufs = vim.tbl_filter(function(b)
          return api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
        end, bufs)

        if #bufs == 0 then return "" end
        if config.hide_single and #bufs <= 1 then return "" end

        local left_sep, right_sep = winbuf.get_separators()
        local padding_str = pad(config.padding or 1)
        local max_name = config.max_name_length or 18
        local show_close = config.show_close_icon ~= false
        local show_ordinal = config.show_buffer_ordinal or false
        local do_truncate = config.truncate_names ~= false
        local diag_enabled = config.diagnostics and config.diagnostics ~= false
        local indicator = config.indicator and config.indicator.style or "bar"

        local has_devicons, devicons = false, nil
        if config.icons and config.icons.enabled then
          has_devicons, devicons = pcall(require, "nvim-web-devicons")
        end

        local parts = {}

        for idx, buf in ipairs(bufs) do
          local raw_name = vim.fn.fnamemodify(api.nvim_buf_get_name(buf), ":t")
          if raw_name == "" then raw_name = config.no_name end

          local display = raw_name
          if do_truncate then display = truncate(raw_name, max_name) end
          display = escape_pct(display)

          local active = buf == cur_buf
          local modified = vim.bo[buf].modified

          local base_hl = active and "WinBufActive" or "WinBufInactive"
          local hl = "%#" .. base_hl .. "#"
          local sep_hl = active and "%#WinBufActiveSep#" or "%#WinBufInactiveSep#"
          local close_hl = active and "%#WinBufActiveClose#" or "%#WinBufInactiveClose#"
          local mod_hl = active and "%#WinBufActiveModified#" or "%#WinBufInactiveModified#"

          -- Determine diagnostics
          local counts = get_diagnostics(buf)

          -- Determine Git status
          local is_modified = false
          local is_untracked = false

          local ok_cache, cache_mod = pcall(require, "gitsigns.cache")
          if ok_cache and cache_mod and cache_mod.cache then
            local bcache = cache_mod.cache[buf]
            if bcache then
              if bcache.git_obj and bcache.git_obj.object_name == nil then
                is_untracked = true
              elseif bcache.hunks and #bcache.hunks > 0 then
                is_modified = true
              end
            end
          end

          local git_status = vim.b[buf].gitsigns_status_dict
          if git_status and not is_untracked and not is_modified then
            if (git_status.changed and git_status.changed > 0) or (git_status.removed and git_status.removed > 0) then
              is_modified = true
            elseif git_status.added and git_status.added > 0 then
              is_untracked = true
            end
          end

          local text_hl = base_hl
          if counts.error > 0 then
            local err_fg = (get_hl(0, { name = "DiagnosticError", link = false }) or {}).fg or 16468276
            text_hl = get_custom_hl(base_hl, "Error", err_fg)
          elseif counts.warning > 0 then
            local warn_fg = (get_hl(0, { name = "DiagnosticWarn", link = false }) or {}).fg or 16679219
            text_hl = get_custom_hl(base_hl, "Warn", warn_fg)
          elseif is_untracked then
            local add_fg = (get_hl(0, { name = "GitSignsAdd", link = false }) or {}).fg or 12106534
            text_hl = get_custom_hl(base_hl, "GitAdd", add_fg)
          elseif is_modified then
            local mod_fg = (get_hl(0, { name = "GitSignsChange", link = false }) or {}).fg or 16432431
            text_hl = get_custom_hl(base_hl, "GitMod", mod_fg)
          end

          local text_hl_str = "%#" .. text_hl .. "#"
          local content = {}

          if show_ordinal then
            table.insert(content, tostring(idx) .. " ")
          end

          if has_devicons then
            local icon, icon_hl = devicons.get_icon(raw_name)
            if icon then
              if active and icon_hl then
                table.insert(content, "%#" .. icon_hl .. "#" .. icon .. " " .. hl)
              else
                table.insert(content, icon .. " ")
              end
            end
          end

          table.insert(content, text_hl_str .. display .. hl)

          if modified then
            table.insert(content, " " .. mod_hl .. config.modified_icon .. hl)
          end

          if diag_enabled then
            local total = counts.error + counts.warning
            local diag_text = ""

            if total > 0 and config.diagnostics_indicator then
              local level = counts.error > 0 and "error" or "warning"
              diag_text = config.diagnostics_indicator(total, level, counts)
            elseif total > 0 then
              if counts.error > 0 then
                local dhl = active and "%#WinBufActiveDiagError#" or "%#WinBufInactiveDiagError#"
                diag_text = diag_text .. " " .. dhl .. " " .. counts.error .. hl
              end
              if counts.warning > 0 then
                local dhl = active and "%#WinBufActiveDiagWarn#" or "%#WinBufInactiveDiagWarn#"
                diag_text = diag_text .. " " .. dhl .. " " .. counts.warning .. hl
              end
            end

            if diag_text ~= "" then
              table.insert(content, diag_text)
            end
          end

          local close_btn = ""
          if show_close then
            local click_fn = string.format("%%@v:lua.require'winbuf.render'.close_click_%d@", buf)
            close_btn = " " .. close_hl .. click_fn .. config.close_icon .. "%X" .. hl
          end

          local click = string.format("%%@v:lua.require'winbuf.render'.switch_click_%d@", buf)
          local tab_content = table.concat(content, "")
          local tab

          if indicator == "underline" and active then
            local ul = "%#WinBufActiveUnderline#"
            tab = sep_hl .. left_sep
              .. ul .. click .. padding_str .. tab_content .. close_btn .. padding_str .. "%X"
              .. sep_hl .. right_sep
          else
            tab = sep_hl .. left_sep
              .. hl .. click .. padding_str .. tab_content .. close_btn .. padding_str .. "%X"
              .. sep_hl .. right_sep
          end

          table.insert(parts, tab)
        end

        return table.concat(parts, "") .. "%#WinBufFill#"
      end

      -- Override NvChad default statusline to display dropbar breadcrumbs
      local ok_stl, stl_default = pcall(require, "nvchad.stl.default")
      if ok_stl then
        local utils_stl = require("nvchad.stl.utils")
        local config_stl = require("nvconfig").ui.statusline
        local sep_style = config_stl.separator_style
        local sep_icons = utils_stl.separators
        local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]
        local sep_l = separators["left"]
        local sep_r = separators["right"]

        package.loaded["nvchad.stl.default"] = function()
          local M_stl = {
            mode = function()
              if not utils_stl.is_activewin() then
                return ""
              end
              local modes = utils_stl.modes
              local m = vim.api.nvim_get_mode().mode
              local current_mode = "%#St_" .. modes[m][2] .. "Mode#  " .. modes[m][1]
              local mode_sep1 = "%#St_" .. modes[m][2] .. "ModeSep#" .. sep_r
              return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
            end,

            file = function()
              local dropbar_str = ""
              local buf = utils_stl.stbufnr()
              local win = vim.g.statusline_winid or 0
              if _G.dropbar and _G.dropbar.bars then
                local ok_dropbar, bar_obj = pcall(function() return _G.dropbar.bars[buf][win] end)
                if ok_dropbar and bar_obj and bar_obj.components then
                  if #bar_obj.components == 0 then
                    pcall(bar_obj.update, bar_obj)
                  end
                  local comps = bar_obj.components
                  if comps and #comps > 0 then
                    local max_items = 3
                    local start_idx = 1
                    local show_leading_dots = false
                    if #comps > max_items then
                      start_idx = #comps - max_items + 1
                      show_leading_dots = true
                    end
                    local result = {}
                    if show_leading_dots then
                      local sep_str = bar_obj.separator:cat()
                      local clean_sep = sep_str:gsub("%%#.-#", "")
                      table.insert(result, "%#St_breadcrumbs#… %#St_breadcrumbs#" .. clean_sep)
                    end
                    for i = start_idx, #comps do
                      local comp = comps[i]
                      local comp_str = comp:cat()
                      local clean_comp = comp_str:gsub("%%#.-#", "")
                      table.insert(result, "%#St_breadcrumbs#" .. clean_comp)
                      if i < #comps then
                        local sep_str = bar_obj.separator:cat()
                        local clean_sep = sep_str:gsub("%%#.-#", "")
                        table.insert(result, "%#St_breadcrumbs#" .. clean_sep)
                      end
                    end
                    dropbar_str = table.concat(result)
                  end
                end
              end

              if dropbar_str ~= "" then
                return "%#St_file# " .. dropbar_str .. "%#St_file_sep#" .. sep_r
              else
                local x = utils_stl.file()
                local name = " " .. x[2] .. (sep_style == "default" and " " or "")
                return "%#St_file# " .. x[1] .. name .. "%#St_file_sep#" .. sep_r
              end
            end,

            git = function()
              return "%#St_gitIcons#" .. utils_stl.git()
            end,

            lsp_msg = function()
              return "%#St_LspMsg#" .. utils_stl.lsp_msg()
            end,

            diagnostics = utils_stl.diagnostics,

            lsp = function()
              return "%#St_Lsp#" .. utils_stl.lsp()
            end,

            cwd = function()
              local icon = "%#St_cwd_icon#" .. "󰉋 "
              local name = vim.uv.cwd()
              name = "%#St_cwd_text#" .. " " .. (name:match "([^/\\]+)[/\\]*$" or name) .. " "
              return (vim.o.columns > 85 and ("%#St_cwd_sep#" .. sep_l .. icon .. name)) or ""
            end,

            cursor = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon# %#St_pos_text# %l/%v ",
            ["%="] = "%="
          }
          return utils_stl.generate("default", M_stl)
        end
      end

      -- Re-trigger a refresh of all windows to immediately apply the override
      vim.schedule(function()
        pcall(winbuf_render.refresh_all)
      end)
    end,
  },
}
