require "nvchad.mappings"

-- Delete Neovim default diagnostics mappings starting with <C-w> to prevent which-key interception
pcall(vim.keymap.del, "n", "<C-w>d")
pcall(vim.keymap.del, "n", "<C-w><C-d>")

local map = vim.keymap.set

-- 1. File & Buffer Operations
-- Save file
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- New file
map({ "n", "i", "v" }, "<C-n>", "<cmd>enew<CR>", { desc = "New file" })

-- Close editor/buffer
map({ "n", "i", "v" }, "<C-w>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close buffer", nowait = true })

map({ "n", "i", "v" }, "<C-F4>", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Close buffer" })

-- Switch Tab/Buffer
map({ "n", "i", "v" }, "<C-Tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })

map({ "n", "i", "v" }, "<C-PageDown>", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })

map({ "n", "i", "v" }, "<C-S-Tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })

map({ "n", "i", "v" }, "<C-PageUp>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })

-- Split Editor
map({ "n", "i", "v" }, "<C-\\>", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map({ "n", "i", "v" }, "<C-S-\\>", "<cmd>split<CR>", { desc = "Split horizontally" })


-- 2. Editing & Navigation
-- Clipboard (Copy, Cut, Paste)
map("v", "<C-c>", '"+y', { desc = "Copy selection" })
map("v", "<C-x>", '"+d', { desc = "Cut selection" })
map("n", "<C-v>", '"+p', { desc = "Paste clipboard" })
map("v", "<C-v>", '"+p', { desc = "Paste clipboard" })
map("i", "<C-v>", "<C-r><C-o>+", { desc = "Paste clipboard" })

-- Undo / Redo
map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<Cmd>undo<CR>", { desc = "Undo" })
map("v", "<C-z>", "<Cmd>undo<CR>", { desc = "Undo" })

map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("i", "<C-y>", "<Cmd>redo<CR>", { desc = "Redo" })
map("v", "<C-y>", "<Cmd>redo<CR>", { desc = "Redo" })

-- Delete Word (Ctrl+Delete / Ctrl+Backspace)
map("n", "<C-Delete>", "dw", { desc = "Delete word forward" })
map("i", "<C-Delete>", "<C-o>dw", { desc = "Delete word forward" })
map("n", "<C-Backspace>", "db", { desc = "Delete word backward" })
map("i", "<C-Backspace>", "<C-w>", { desc = "Delete word backward" })
map("i", "<C-H>", "<C-w>", { desc = "Delete word backward" })

-- Select All
map({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Move Lines
map("n", "<A-Up>", "<cmd>m .-2<CR>===", { desc = "Move line up" })
map("n", "<A-Down>", "<cmd>m .+1<CR>===", { desc = "Move line down" })
map("i", "<A-Up>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("i", "<A-Down>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })

-- Duplicate Lines
map("n", "<S-A-Up>", "<cmd>t .-1<CR>", { desc = "Duplicate line up" })
map("n", "<S-A-Down>", "<cmd>t .<CR>", { desc = "Duplicate line down" })
map("i", "<S-A-Up>", "<Esc><cmd>t .-1<CR>gi", { desc = "Duplicate line up" })
map("i", "<S-A-Down>", "<Esc><cmd>t .<CR>gi", { desc = "Duplicate line down" })
map("v", "<S-A-Up>", ":t '<-1<CR>gv=gv", { desc = "Duplicate lines up" })
map("v", "<S-A-Down>", ":t '><CR>gv=gv", { desc = "Duplicate lines down" })

map("n", "<A-S-Up>", "<cmd>t .-1<CR>", { desc = "Duplicate line up" })
map("n", "<A-S-Down>", "<cmd>t .<CR>", { desc = "Duplicate line down" })
map("i", "<A-S-Up>", "<Esc><cmd>t .-1<CR>gi", { desc = "Duplicate line up" })
map("i", "<A-S-Down>", "<Esc><cmd>t .<CR>gi", { desc = "Duplicate line down" })
map("v", "<A-S-Up>", ":t '<-1<CR>gv=gv", { desc = "Duplicate lines up" })
map("v", "<A-S-Down>", ":t '><CR>gv=gv", { desc = "Duplicate lines down" })

-- Indentation (Tab & Shift-Tab)
map("v", "<Tab>", ">gv", { desc = "Indent selection" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent selection" })
map("i", "<S-Tab>", "<C-d>", { desc = "Outdent line" })
map("n", "<Tab>", ">>", { desc = "Indent line" })
map("n", "<S-Tab>", "<<", { desc = "Outdent line" })

-- Delete Line
map("n", "<C-S-k>", "dd", { desc = "Delete line" })
map("i", "<C-S-k>", "<Esc>ddi", { desc = "Delete line" })


-- 3. Search & Replace (Telescope / Native)
-- Quick Open / Go to file
map({ "n", "i", "v" }, "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Search files (Quick open)" })

-- Find in current file
map({ "n", "i", "v" }, "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in file" })

-- Global search (Search in project)
map({ "n", "i", "v" }, "<C-S-f>", "<cmd>Telescope live_grep<CR>", { desc = "Search in project" })
map({ "n", "i", "v" }, "<C-S-F>", "<cmd>Telescope live_grep<CR>", { desc = "Search in project" })
map({ "n", "i", "v" }, "<A-S-f>", "<cmd>Telescope live_grep<CR>", { desc = "Search in project (Alternative)" })
map({ "n", "i", "v" }, "<A-S-F>", "<cmd>Telescope live_grep<CR>", { desc = "Search in project (Alternative)" })

-- Find and Replace
map("n", "<C-h>", ":%s/", { desc = "Find and replace" })
map("v", "<C-h>", ":s/", { desc = "Find and replace in selection" })


-- 4. General UI & Terminal
-- Toggle Sidebar (File explorer)
map({ "n", "i", "v" }, "<C-b>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Toggle Terminal (Floating)
map({ "n", "t" }, "<A-e>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Toggle floating terminal" })

-- Toggle Comment helper functions
local function toggle_comment_empty_line(mode)
  local cs = vim.bo.commentstring
  if not cs or cs == "" then
    cs = "// %s" -- fallback
  end
  local placeholder = "%s"
  local index = cs:find(placeholder, 1, true)
  local insert_str = ""
  local left_keys = ""
  if index then
    local prefix = cs:sub(1, index - 1)
    local suffix = cs:sub(index + #placeholder)
    insert_str = prefix .. suffix
    if #suffix > 0 then
      left_keys = string.rep("<Left>", #suffix)
    end
  else
    insert_str = cs
  end

  local keys = ""
  if mode == "i" then
    keys = vim.api.nvim_replace_termcodes(insert_str .. left_keys, true, false, true)
  else
    keys = vim.api.nvim_replace_termcodes("i" .. insert_str .. left_keys, true, false, true)
  end
  vim.api.nvim_feedkeys(keys, "n", true)
end

local function toggle_comment_insert()
  local line = vim.api.nvim_get_current_line()
  if line:match("^%s*$") then
    toggle_comment_empty_line("i")
  else
    local keys = vim.api.nvim_replace_termcodes("<Esc>gccgi", true, false, true)
    vim.api.nvim_feedkeys(keys, "m", true)
  end
end

local function toggle_comment_normal()
  local line = vim.api.nvim_get_current_line()
  if line:match("^%s*$") then
    toggle_comment_empty_line("n")
  else
    vim.api.nvim_feedkeys("gcc", "m", true)
  end
end

-- Toggle Comment
map("n", "<C-/>", toggle_comment_normal, { desc = "Toggle comment" })
map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })
map("i", "<C-/>", toggle_comment_insert, { desc = "Toggle comment" })
map("n", "<C-_>", toggle_comment_normal, { desc = "Toggle comment" })
map("v", "<C-_>", "gc", { desc = "Toggle comment", remap = true })
map("i", "<C-_>", toggle_comment_insert, { desc = "Toggle comment" })

-- Go to line number
map({ "n", "i", "v" }, "<C-g>", ":", { desc = "Go to line" })

-- Go back / forward in cursor history
map("n", "<A-Left>", "<C-o>", { desc = "Go back in history" })
map("n", "<A-Right>", "<C-i>", { desc = "Go forward in history" })

-- LSP Navigation & Code actions
map("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
map("i", "<C-LeftMouse>", "<Esc><LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
map("n", "<S-F12>", vim.lsp.buf.references, { desc = "Find references" })
map({ "n", "i", "v" }, "<A-S-f>", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format document" })
map({ "n", "i", "v" }, "<C-S-i>", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format document" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "i", "v" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code action" })

-- Shift + Scroll Wheel for Horizontal Scrolling with Jump-point saving
local last_scroll_time = 0
local function save_scroll_jump()
  local now = vim.uv.hrtime() / 1000000 -- Convert nanoseconds to milliseconds
  if now - last_scroll_time > 1000 then -- 1 second threshold
    vim.cmd("normal! m'")
  end
  last_scroll_time = now
end

map({ "n", "i", "v" }, "<S-ScrollWheelDown>", function()
  save_scroll_jump()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>5zl<C-o>5l", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("5zl5l", true, false, true), "n", true)
  end
end, { desc = "Scroll right" })

map({ "n", "i", "v" }, "<S-ScrollWheelUp>", function()
  save_scroll_jump()
  if vim.api.nvim_get_mode().mode == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>5zh<C-o>5h", true, false, true), "n", true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("5zh5h", true, false, true), "n", true)
  end
end, { desc = "Scroll left" })

-- Default command mode mapper from NvChad config, keeping it
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Custom Image Preview using Chafa and NvChad floating terminal
local function preview_image()
  local path = nil

  -- If in NvimTree
  if vim.bo.filetype == "NvimTree" then
    local api = require("nvim-tree.api")
    local node = api.tree.get_node_under_cursor()
    if node and node.absolute_path then
      path = node.absolute_path
    end
  else
    -- Get path under cursor
    local cword = vim.fn.expand("<cfile>")
    if cword and cword ~= "" then
      if cword:match("^/") then
        path = cword
      elseif cword:match("^@/") then
        local root = vim.fs.root(0, { ".git", "package.json" })
        if root then
          path = root .. "/src/" .. cword:sub(3)
        end
      else
        -- Resolve relative path relative to current buffer's directory
        local current_dir = vim.fn.expand("%:p:h")
        path = current_dir .. "/" .. cword
      end
      if path then
        path = vim.fn.fnamemodify(path, ":p")
      end
    end
  end

  if path then
    -- Check if it's an image file
    local ext = path:match("^.+(%..+)$")
    if ext then
      ext = ext:lower()
      local valid_extensions = {
        [".png"] = true,
        [".jpg"] = true,
        [".jpeg"] = true,
        [".gif"] = true,
        [".webp"] = true,
        [".bmp"] = true,
        [".ico"] = true,
        [".svg"] = true,
      }
      if valid_extensions[ext] then
        -- Open floating terminal natively
        local width = math.floor(vim.o.columns * 0.9)
        local height = math.floor(vim.o.lines * 0.9)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        local buf = vim.api.nvim_create_buf(false, true)
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
        })

        vim.fn.termopen("chafa --symbols block+braille+sextant --colors full --color-space din99d -w 9 " .. vim.fn.shellescape(path) .. " && echo '' && echo 'Press any key to close...' && read -n 1")

        vim.api.nvim_create_autocmd("TermClose", {
          buffer = buf,
          callback = function()
            pcall(vim.api.nvim_win_close, win, { force = true })
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end,
        })
        return
      end
    end
  end

  print("No previewable image found under cursor.")
end

map("n", "<leader>p", preview_image, { desc = "Preview image under cursor / in NvimTree" })
