return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
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
      }
    end,
    config = function()
      -- Map Ctrl+d dan Ctrl+Shift+l di semua mode (Normal, Visual, dan Select Mode)
      -- Kita HARUS menyetel remap = true agar Neovim dapat mengevaluasi shortcut <Plug> bawaan plugin
      vim.keymap.set("n", "<C-d>", "<Plug>(VM-Find-Under)", { remap = true, silent = true, desc = "VM: Find Under" })
      vim.keymap.set("x", "<C-d>", "<Plug>(VM-Find-Subword-Under)", { remap = true, silent = true, desc = "VM: Find Under (Visual)" })
      vim.keymap.set("s", "<C-d>", "<C-g><Plug>(VM-Find-Subword-Under)", { remap = true, silent = true, desc = "VM: Find Under (Select)" })

      vim.keymap.set("n", "<C-S-l>", "<Plug>(VM-Select-All)", { remap = true, silent = true, desc = "VM: Select All" })
      vim.keymap.set("x", "<C-S-l>", "<Plug>(VM-Select-All)", { remap = true, silent = true, desc = "VM: Select All (Visual)" })
      vim.keymap.set("s", "<C-S-l>", "<C-g><Plug>(VM-Select-All)", { remap = true, silent = true, desc = "VM: Select All (Select)" })
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
}
