require "nvchad.options"

-- add yours here!
vim.opt.swapfile = false
vim.opt.wrap = false
vim.opt.sidescrolloff = 8
vim.opt.virtualedit = "all"
vim.opt.autoread = true

-- Mengaktifkan kedipan kursor (blinking) di semua mode dengan mempertahankan bentuk cursor masing-masing mode
vim.opt.guicursor =
  "n-v-c-sm:block-blinkwait700-blinkoff400-blinkon250,i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250,r-cr-o:hor20-blinkwait700-blinkoff400-blinkon250"

-- Perilaku Seleksi Teks (Select Mode seperti VS Code)
-- Saat memblok dengan mouse atau Shift + Arrow, ketikan baru akan langsung menimpa seleksi
vim.opt.selectmode = "mouse,key"
vim.opt.keymodel = "startsel,stopsel"

-- Neovide Configuration
if vim.g.neovide then
  -- Gunakan font MesloLGS NF yang terinstal di sistem Anda
  vim.o.guifont = "MesloLGS NF:h12"

  -- Mengatur tinggi baris (line height/spacing) secara dinamis
  -- linespace = 12 untuk buffer script/code, linespace = 10 untuk dashboard, terminal, dan antigravity
  local linespace_group = vim.api.nvim_create_augroup("NeovideLineSpace", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "BufWinEnter", "FileType" }, {
    group = linespace_group,
    callback = function()
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype
      local bufname = vim.api.nvim_buf_get_name(0)

      local is_dashboard = (filetype == "nvdash")
      local is_terminal = (buftype == "terminal")
      local is_antigravity = (bufname:match "term://.*agy" ~= nil)
      local is_nvimtree = (filetype == "NvimTree")
      local is_nofile = (buftype == "nofile")

      if is_dashboard or is_terminal or is_antigravity or is_nvimtree or is_nofile then
        vim.opt.linespace = 3
      else
        vim.opt.linespace = 12
      end
    end,
  })

  -- Animasi kursor (kecepatan & gaya)
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.8

  -- Aktifkan smooth scroll (0.08 agar sangat cepat dan responsif mirip VS Code tanpa delay)
  vim.g.neovide_scroll_animation_length = 0.08

  -- Transparansi jendela (0.0 - 1.0)
  vim.g.neovide_opacity = 1

  -- Efek blur pada background (membutuhkan transparansi aktif)
  vim.g.neovide_window_blurred = false

  -- Konfigurasi tambahan untuk integrasi macOS
  vim.g.neovide_input_macos_option_key_is_meta = "both"

  -- Mengingat ukuran dan posisi jendela terakhir
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_remember_window_position = true

  -- Menghilangkan teks judul jendela di title bar
  vim.o.title = true
  vim.o.titlestring = " "
end
