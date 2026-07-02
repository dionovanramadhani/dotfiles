require "nvchad.autocmds"

-- Automatically highlight references of the symbol under the cursor (VS Code style)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight") then
      local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
      
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = highlight_group,
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = highlight_group,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
      
      vim.api.nvim_create_autocmd("LspDetach", {
        group = highlight_group,
        buffer = ev.buf,
        callback = function(ev2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "LspDocumentHighlight", buffer = ev2.buf })
        end,
      })
    end
  end,
})

-- Intercept binary image files to show visual terminal preview instead of binary text
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.webp", "*.gif", "*.bmp", "*.ico" },
  callback = function(args)
    local path = vim.fn.expand(args.match)
    if path and path ~= "" then
      -- Schedule buffer deletion to clean up the buffer Neovim initialized for it
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end)
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
    end
  end,
})

-- Automatic non-disruptive image hover preview when cursor rests on an image path
local hover_win = nil
local hover_buf = nil

local function close_hover_preview()
  if hover_win and vim.api.nvim_win_is_valid(hover_win) then
    pcall(vim.api.nvim_win_close, hover_win, { force = true })
  end
  if hover_buf and vim.api.nvim_buf_is_valid(hover_buf) then
    pcall(vim.api.nvim_buf_delete, hover_buf, { force = true })
  end
  hover_win = nil
  hover_buf = nil
end

local function check_and_hover_preview()
  if vim.bo.filetype == "NvimTree" or vim.bo.filetype == "terminal" then
    return
  end

  local cword = vim.fn.expand("<cfile>")
  if not cword or cword == "" then
    close_hover_preview()
    return
  end

  local path = nil
  if cword:match("^/") then
    path = cword
  elseif cword:match("^@/") then
    local root = vim.fs.root(0, { ".git", "package.json" })
    if root then
      path = root .. "/src/" .. cword:sub(3)
    end
  else
    local current_dir = vim.fn.expand("%:p:h")
    path = current_dir .. "/" .. cword
  end

  if path then
    path = vim.fn.fnamemodify(path, ":p")
    local ext = path:match("^.+(%..+)$")
    if ext then
      ext = ext:lower()
      local valid = {
        [".png"] = true,
        [".jpg"] = true,
        [".jpeg"] = true,
        [".gif"] = true,
        [".webp"] = true,
        [".bmp"] = true,
        [".ico"] = true,
        [".svg"] = true,
      }
      if valid[ext] and vim.fn.filereadable(path) == 1 then
        if hover_win then
          -- Hover already open
          return
        end

        local current_win = vim.api.nvim_get_current_win()
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        hover_buf = vim.api.nvim_create_buf(false, true)
        hover_win = vim.api.nvim_open_win(hover_buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
        })

        vim.fn.termopen("chafa --symbols block+braille+sextant --colors full --color-space din99d -w 9 " .. vim.fn.shellescape(path) .. " && sleep 100000")

        -- Return focus immediately so the user can continue typing/navigating
        vim.api.nvim_set_current_win(current_win)
        return
      end
    end
  end

  close_hover_preview()
end

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  callback = check_and_hover_preview,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
  pattern = "*",
  callback = close_hover_preview,
})
