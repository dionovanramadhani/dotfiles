require "nvchad.mappings"

-- Delete Neovim default diagnostics mappings starting with <C-w> to prevent which-key interception
pcall(vim.keymap.del, "n", "<C-w>d")
pcall(vim.keymap.del, "n", "<C-w><C-d>")

local map = vim.keymap.set

-- Custom function to toggle between Go to Definition and Find References
_G.go_to_definition_or_references = function()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
  if vim.tbl_isempty(clients) then
    vim.lsp.buf.definition()
    return
  end

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) then
      vim.lsp.buf.definition()
      return
    end

    local target = result
    if vim.tbl_islist(result) then
      target = result[1]
    end

    local target_uri = target.uri or target.targetUri
    local target_range = target.range or target.targetSelectionRange

    if not target_uri or not target_range then
      vim.lsp.buf.definition()
      return
    end

    local current_uri = vim.uri_from_bufnr(0)
    local current_cursor = vim.api.nvim_win_get_cursor(0)
    local current_row = current_cursor[1] - 1

    local is_at_definition = (target_uri == current_uri) and (target_range.start.line == current_row)

    if is_at_definition then
      vim.lsp.buf.references()
    else
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      local offset_encoding = client and client.offset_encoding or "utf-16"
      vim.lsp.util.jump_to_location(target, offset_encoding, true)
    end
  end)
end

-- 1. File & Buffer Operations
-- Save file
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- New file
map({ "n", "i", "v" }, "<C-n>", "<cmd>enew | startinsert<CR>", { desc = "New file" })

-- Close editor/buffer
map({ "n", "i", "v" }, "<C-w>", function()
  vim.cmd("WinBufClose")
end, { desc = "Close buffer", nowait = true })

map({ "n", "i", "v" }, "<C-F4>", function()
  vim.cmd("WinBufClose")
end, { desc = "Close buffer" })

-- Switch Tab/Buffer
map({ "n", "i", "v" }, "<C-Tab>", function()
  vim.cmd("WinBufNext")
end, { desc = "Next buffer" })

map({ "n", "i", "v" }, "<C-PageDown>", function()
  vim.cmd("WinBufNext")
end, { desc = "Next buffer" })

map({ "n", "i", "v" }, "<C-S-Tab>", function()
  vim.cmd("WinBufPrev")
end, { desc = "Previous buffer" })

map({ "n", "i", "v" }, "<C-PageUp>", function()
  vim.cmd("WinBufPrev")
end, { desc = "Previous buffer" })

-- Split Editor
map({ "n", "i", "v" }, "<C-\\>", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map({ "n", "i", "v" }, "<C-S-\\>", "<cmd>split<CR>", { desc = "Split horizontally" })

-- Move focus between splits (Ctrl + Alt + Arrows)
map("n", "<C-A-Left>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-A-Down>", "<C-w>j", { desc = "Focus bottom window" })
map("n", "<C-A-Up>", "<C-w>k", { desc = "Focus top window" })
map("n", "<C-A-Right>", "<C-w>l", { desc = "Focus right window" })

-- Move split window positions (Ctrl + Shift + Arrows)
map("n", "<C-S-Left>", "<C-w>H", { desc = "Move window left" })
map("n", "<C-S-Down>", "<C-w>J", { desc = "Move window down" })
map("n", "<C-S-Up>", "<C-w>K", { desc = "Move window up" })
map("n", "<C-S-Right>", "<C-w>L", { desc = "Move window right" })

-- Move current buffer to adjacent splits (Ctrl + Alt + Shift + Arrows)
map("n", "<C-A-S-Left>", "<cmd>WinBufMoveLeft<CR>", { desc = "Move buffer left" })
map("n", "<C-A-S-Down>", "<cmd>WinBufMoveDown<CR>", { desc = "Move buffer down" })
map("n", "<C-A-S-Up>", "<cmd>WinBufMoveUp<CR>", { desc = "Move buffer up" })
map("n", "<C-A-S-Right>", "<cmd>WinBufMoveRight<CR>", { desc = "Move buffer right" })


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

-- Deletion (Linux style Ctrl + Backspace)
map("n", "<C-Backspace>", "db", { desc = "Delete word backward" })
map("i", "<C-Backspace>", "<C-w>", { desc = "Delete word backward" })
map("n", "<C-BS>", "db", { desc = "Delete word backward" })
map("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })

map("n", "<C-H>", "d0", { desc = "Delete to start of line" })
map("i", "<C-H>", "<C-u>", { desc = "Delete to start of line" })

map("n", "<C-Delete>", "dw", { desc = "Delete word forward" })
map("i", "<C-Delete>", "<C-o>dw", { desc = "Delete word forward" })

-- Select All
map({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Line Navigation (Linux style Ctrl + Left/Right)
map({ "n", "v" }, "<C-Left>", "^", { desc = "Go to start of line" })
map({ "n", "v" }, "<C-Right>", "$", { desc = "Go to end of line" })
map("i", "<C-Left>", "<Home>", { desc = "Go to start of line" })
map("i", "<C-Right>", "<End>", { desc = "Go to end of line" })

-- Ctrl + Enter (New line below) and Shift + Enter (Add semicolon at end of line)
map("n", "<C-CR>", "o", { desc = "New line below" })
map("i", "<C-CR>", "<Esc>o", { desc = "New line below" })
map("n", "<S-CR>", "A;<Esc>", { desc = "Add semicolon to end of line" })
map("i", "<S-CR>", "<Esc>A;<Esc>a", { desc = "Add semicolon to end of line" })

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

-- Helper function to get visual/select mode selected text
local function get_visual_selection()
  local type_map = {
    s = "v",
    S = "V",
    ["\19"] = "\22",
    v = "v",
    V = "V",
    ["\22"] = "\22",
  }
  local raw_mode = vim.fn.mode()
  local mode_type = type_map[raw_mode] or "v"
  local s_pos = vim.fn.getpos("v")
  local e_pos = vim.fn.getpos(".")
  local region = vim.fn.getregion(s_pos, e_pos, { type = mode_type })
  return table.concat(region, "\n")
end

local function search_in_file()
  local mode = vim.fn.mode()
  local text = ""
  if mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19" then
    text = get_visual_selection()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  else
    text = vim.fn.expand("<cword>")
  end
  require("telescope.builtin").current_buffer_fuzzy_find({ default_text = text })
end

local function search_in_project()
  local mode = vim.fn.mode()
  local text = ""
  if mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19" then
    text = get_visual_selection()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  else
    text = vim.fn.expand("<cword>")
  end
  require("telescope.builtin").live_grep({ default_text = text })
end

-- Find in current file
map({ "n", "x", "s" }, "<C-f>", search_in_file, { desc = "Search in file" })
map("i", "<C-f>", function()
  require("telescope.builtin").current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Search in file" })

-- Global search (Search in project)
map({ "n", "x", "s" }, "<C-S-f>", search_in_project, { desc = "Search in project" })
map({ "n", "x", "s" }, "<C-S-F>", search_in_project, { desc = "Search in project" })
map("i", "<C-S-f>", function()
  require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Search in project" })
map("i", "<C-S-F>", function()
  require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
end, { desc = "Search in project" })

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

-- Go back / forward in cursor history (macOS style Cmd + [ / ])
map("n", "<C-[>", "<C-o>", { desc = "Go back in history" })
map("n", "<C-]>", "<C-i>", { desc = "Go forward in history" })

-- Option/Alt + Arrow keys for word-by-word navigation (macOS style)
map({ "n", "v" }, "<A-Left>", "b", { desc = "Move word backward" })
map({ "n", "v" }, "<A-Right>", "w", { desc = "Move word forward" })
map("i", "<A-Left>", "<C-o>b", { desc = "Move word backward" })
map("i", "<A-Right>", "<C-o>w", { desc = "Move word forward" })

-- LSP Navigation & Code actions
map("n", "<F12>", function() _G.go_to_definition_or_references() end, { desc = "Go to definition or references" })
map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua _G.go_to_definition_or_references()<CR>", { desc = "Go to definition or references" })
map("i", "<C-LeftMouse>", "<Esc><LeftMouse><cmd>lua _G.go_to_definition_or_references()<CR>", { desc = "Go to definition or references" })
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

-- Toggle Antigravity CLI in a vertical terminal split on the right (Cmd + L)
local function toggle_antigravity_cli()
  local agy_win = nil
  local agy_buf = nil

  -- Find an active agy terminal buffer that is still running
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      local is_running = pcall(function() return vim.bo[buf].channel > 0 end) and vim.bo[buf].channel > 0
      if name:match("term://.*agy") and is_running then
        agy_buf = buf
        break
      end
    end
  end

  -- Check if the buffer is visible in any window of the current tabpage
  if agy_buf then
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == agy_buf then
        agy_win = win
        break
      end
    end
  end

  if agy_win then
    -- Close the window to hide it
    vim.api.nvim_win_close(agy_win, true)
  else
    -- Open a vertical split on the right and switch to the agy buffer/terminal
    local width = math.floor(vim.o.columns * 0.30)
    vim.cmd("botright " .. width .. "vsplit")
    if agy_buf and vim.api.nvim_buf_is_valid(agy_buf) then
      vim.api.nvim_set_current_buf(agy_buf)
    else
      vim.cmd("terminal " .. vim.fn.expand("~/.local/bin/agy"))
    end
    vim.cmd("startinsert")
  end
end

map({ "n", "i", "v", "t" }, "<C-l>", toggle_antigravity_cli, { desc = "Toggle Antigravity CLI on the right" })

-- Toggle Neogit (VS Code style Source Control) in a 30% width vertical split
local function toggle_neogit()
  local neogit_win = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "NeogitStatus" then
        neogit_win = win
        break
      end
    end
  end

  if neogit_win then
    vim.api.nvim_win_close(neogit_win, true)
  else
    vim.cmd("Neogit")
    local width = math.floor(vim.o.columns * 0.30)
    vim.cmd("vertical resize " .. width)
  end
end

map({ "n", "i", "v", "t" }, "<C-S-g>", toggle_neogit, { desc = "Toggle Source Control" })
map({ "n", "i", "v", "t" }, "<C-S-G>", toggle_neogit, { desc = "Toggle Source Control" })

-- Scroll viewport using Shift + K (down) and Shift + I (up) in Normal Mode (kecepatan 3 baris)
map("n", "K", "3<C-e>", { desc = "Scroll viewport down" })
map("n", "I", "3<C-y>", { desc = "Scroll viewport up" })

-- Tab / Buffer Navigation (VS Code / Web Browser style)
local function next_tab()
  vim.cmd("WinBufNext")
end

local function prev_tab()
  vim.cmd("WinBufPrev")
end

-- 1. Ctrl + Alt + Arrow Left/Right (Linux style tab switching - insert, visual, terminal mode only to prevent normal mode window navigation conflict)
map({ "i", "v", "t" }, "<C-M-Right>", next_tab, { desc = "Go to next tab" })
map({ "i", "v", "t" }, "<C-M-Left>", prev_tab, { desc = "Go to previous tab" })

-- 2. Ctrl + Shift + [ / ] (Alternative browser style)
map({ "n", "i", "v", "t" }, "<C-S-]>", next_tab, { desc = "Go to next tab" })
map({ "n", "i", "v", "t" }, "<C-S-[>", prev_tab, { desc = "Go to previous tab" })

-- 3. Ctrl + Tab / Ctrl + Shift + Tab
map({ "n", "i", "v", "t" }, "<C-Tab>", next_tab, { desc = "Go to next tab" })
map({ "n", "i", "v", "t" }, "<C-S-Tab>", prev_tab, { desc = "Go to previous tab" })

-- 5. Visual Mode Wrapping (Wrap selection with brackets or quotes)
local function wrap_selection(open_bracket, close_bracket)
  local unnamed_val = vim.fn.getreg('"')
  local unnamed_type = vim.fn.getregtype('"')
  local z_val = vim.fn.getreg('z')
  local z_type = vim.fn.getregtype('z')

  -- Yank current selection to register z
  vim.cmd('normal! "zy')

  local reg_val = vim.fn.getreg('z')
  local reg_type = vim.fn.getregtype('z')
  local new_val = ""

  if reg_type:sub(1, 1) == "\22" then -- Blockwise visual selection (<C-v>)
    local lines = vim.split(reg_val, "\n")
    for i, line in ipairs(lines) do
      if line ~= "" or i < #lines then
        lines[i] = open_bracket .. line .. close_bracket
      end
    end
    new_val = table.concat(lines, "\n")
  elseif reg_type == "V" then -- Linewise visual selection (V)
    new_val = open_bracket .. "\n" .. reg_val .. close_bracket .. "\n"
  else -- Characterwise visual selection (v)
    new_val = open_bracket .. reg_val .. close_bracket
  end

  vim.fn.setreg('z', new_val, reg_type)
  -- Paste back over selection using P (to not clobber unnamed register)
  vim.cmd('normal! gv"zP')

  -- Restore original register values
  vim.fn.setreg('"', unnamed_val, unnamed_type)
  vim.fn.setreg('z', z_val, z_type)
end

-- Keymaps for wrapping in Visual Mode
map("v", "{", function() wrap_selection("{", "}") end, { desc = "Wrap with curly brackets" })
map("v", "}", function() wrap_selection("{", "}") end, { desc = "Wrap with curly brackets" })
map("v", "[", function() wrap_selection("[", "]") end, { desc = "Wrap with square brackets" })
map("v", "]", function() wrap_selection("[", "]") end, { desc = "Wrap with square brackets" })
map("v", "(", function() wrap_selection("(", ")") end, { desc = "Wrap with parentheses" })
map("v", ")", function() wrap_selection("(", ")") end, { desc = "Wrap with parentheses" })
map("v", '"', function() wrap_selection('"', '"') end, { desc = "Wrap with double quotes" })
map("v", "'", function() wrap_selection("'", "'") end, { desc = "Wrap with single quotes" })
map("v", "`", function() wrap_selection("`", "`") end, { desc = "Wrap with backticks" })

