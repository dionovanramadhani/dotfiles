# ⚡ Neovim Configuration (NvChad v2.5 Based - Linux Branch)

This is a personal Neovim configuration customized from **NvChad v2.5**, specifically tailored for Linux environments utilizing standard **Ctrl-based UX** keybindings, native terminal integrations, and AI agent assistance.

---

## 🌟 Key Features

1. **Neovide Optimized**: Pre-configured options for the Neovide GUI (including window transparency set to 0.9, blur window effect, smooth scrolling, and cursor trail animations).
2. **VS Code & Linux Keyboard Layout**: Common shortcuts like `Ctrl + s` (save), `Ctrl + c`/`v` (system clipboard integration), `Ctrl + z`/`y` (undo/redo), `Ctrl + Left/Right` (word movement), and line duplications.
3. **Multi-Cursor Editing (`vim-visual-multi`)**: Press `Ctrl + d` to select matching words one by one (VS Code behavior) and `Ctrl + Shift + l` to select all occurrences in the document.
4. **Image & Hover Previews**:
   - Intercepts image files (`.png`, `.jpg`, etc.) opened in Neovim and renders them directly inside a floating terminal using **Chafa**.
   - Auto hover previews: hovering the cursor over an image path automatically spawns a preview window (which automatically closes when the cursor moves).
   - Manual preview with `<leader>p` for image path under cursor or file selected in NvimTree.
5. **Robust Git Integration**:
   - **Neogit**: Interactive git panel mimicking VS Code source control panel (`Ctrl + Shift + g`).
   - **GitGraph**: Draw interactive Git commit trees visually inside a buffer (`<leader>gg`). Pressing Enter on a commit opens the diff view.
   - **Diffview**: Comprehensive git diff viewer.
   - **Gitsigns**: In-buffer signs and virtual blame text at the end of the line (EOL) with a 500ms delay.
6. **Custom Tabufline**: Fully customized buffer tabline that dynamically colors buffer tabs based on Diagnostic Errors (red font) and Git Signs (added/changed/removed). It also displays unique paths (e.g. `parent_dir/filename`) if multiple files share the same filename.
7. **Breadcrumbs / Sticky Winbar**: Code structure navigation at the top of the editor window via `dropbar.nvim`.
8. **Antigravity AI Assistant (`agy`)**: Seamlessly open/close the **Antigravity AI Agent CLI** inside a 30% split pane on the right side using the `Ctrl + l` keymap.
9. **Auto-Format on Save**: Documents are automatically formatted upon saving using `conform.nvim` (utilizes Prettier for JS, TS, HTML, CSS, JSON, Markdown, and StyLua for Lua configurations).
10. **LSP & Autocomplete**: Modern LSP client settings with custom configurations for `html`, `cssls`, `ts_ls` (TypeScript), `tailwindcss`, `eslint`, `emmet_language_server`, and `prismals`. Autocomplete uses `nvim-cmp` with confirmation on `<Tab>` and navigation using arrow keys.

---

## 📋 System Prerequisites & External Dependencies

To get the full experience and avoid errors, make sure you have the following external dependencies installed on your system:

### 1. Neovim (v0.10+)
Required for modern API features and compatibility with plugins like lazy.nvim, dropbar.nvim, etc.
- **Ubuntu/Debian**:
  ```bash
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update
  sudo apt install neovim
  ```
- **Arch Linux**:
  ```bash
  sudo pacman -S neovim
  ```
- **Fedora**:
  ```bash
  sudo dnf install neovim
  ```

### 2. Antigravity CLI (`agy`) — *CRITICAL for AI Agent Panel*
The configuration includes a custom command toggle (`Ctrl + l`) to open the Antigravity AI Agent CLI directly in a Neovim split pane.
* **Linux / macOS**:
  ```bash
  curl -fsSL https://antigravity.google/cli/install.sh | bash
  ```

> [!IMPORTANT]
> **Authentication & Path Settings**:
> 1. On first installation, you should run `agy` in your terminal to complete the interactive setup and authentication process.
> 2. The Neovim configuration resolves the path to the `agy` binary dynamically at your home directory (`~/.local/bin/agy`). Make sure this directory is added to your system's `$PATH`.

### 3. Chafa — *Required for Image Previewing*
Renders images directly in your terminal. Required for the hover preview and image buffer interceptor.
- **Ubuntu/Debian**: `sudo apt install chafa`
- **Arch Linux**: `sudo pacman -S chafa`
- **Fedora**: `sudo dnf install chafa`

### 4. Nerd Font (Icon Pack)
Required for rendering editor, git, and language icons correctly.
- Recommended: **MesloLGS Nerd Font Mono** or **JetBrainsMono Nerd Font**. Download it and install to your user fonts folder (e.g., `~/.local/share/fonts/`) and refresh the font cache using `fc-cache -fv`.

### 5. Git & System Clipboard (xclip / wl-clipboard)
Required for package management (lazy.nvim) and clipboard sharing between Neovim and the system clipboard.
- **Ubuntu/Debian (X11)**: `sudo apt install git xclip`
- **Ubuntu/Debian (Wayland)**: `sudo apt install git wl-clipboard`
- **Arch Linux**: `sudo pacman -S git xclip wl-clipboard`

### 6. Node.js & npm / yarn
Required for Mason to install and run Language Servers (LSP) and formatters (like Prettier).
- **Ubuntu/Debian**: `sudo apt install nodejs npm`
- **Arch Linux**: `sudo pacman -S nodejs npm`

### 7. Neovide (Optional GUI)
If you prefer running Neovim as a desktop GUI app, Neovide is highly recommended.
- **Flatpak**: `flatpak install flathub org.neovide.neovide`

---

## 🛠️ Step-by-Step Installation

### Step 1: Back up Existing Neovim Configuration (Optional)
If you have a prior Neovim setup, back it up to prevent conflicts:
```bash
# Backup config directory
mv ~/.config/nvim ~/.config/nvim.bak

# Backup data, state, and cache directories (optional but recommended)
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### Step 2: Clone/Copy This Configuration
Copy or clone this directory into your Neovim config path:
```bash
# Copying from your local dotfiles directory
cp -r /Users/dionovan/project/portfolio/dotfiles/nvim ~/.config/nvim
```
*(Adjust the source path if you are transferring files to a new Linux system).*

### Step 3: Initialize Neovim & Boot Plugins
Launch Neovim from your terminal:
```bash
nvim
```
Upon the first startup:
1. **Lazy.nvim** will automatically download and install all configured plugins. Let the process finish.
2. Exit Neovim (`:q`) and restart it so the **Base46** theme and custom tabufline elements load and cache properly.

### Step 4: Install LSP & Formatters via Mason
Inside Neovim, open the Mason panel to install needed language servers and formatter tools:
```vim
:Mason
```
Install the following for complete integration:
- **LSP Servers**: `html-lsp`, `css-lsp`, `typescript-language-server` (`ts_ls`), `tailwindcss-language-server`, `emmet-language-server`, `eslint-lsp`, `prisma-language-server` (`prismals`).
- **Formatters**: `prettier`, `stylua`.

*Note: In `configs/conform.lua`, Prettier is configured to run specifically from Mason's binaries (`~/.local/share/nvim/mason/bin/prettier`) to prevent project-local prettier errors.*

---

## ⌨️ Custom Keymaps (Keyboard Shortcuts)

Keybindings are configured to match standard Linux and VS Code shortcuts, utilizing the Control key (`<C-...>`).

### 1. File & Buffer Operations
| Keymap | Mode | Description |
| --- | --- | --- |
| `Ctrl + s` | Normal, Insert, Visual | Save active file (`:w`) |
| `Ctrl + n` | Normal, Insert, Visual | Create a new file/buffer |
| `Ctrl + w` or `Ctrl + F4` | Normal, Insert, Visual | Close active buffer / tab |
| `Ctrl + \` | Normal, Insert, Visual | Split window vertically |
| `Ctrl + Shift + \` | Normal, Insert, Visual | Split window horizontally |
| `Ctrl + Alt + ↑/↓/←/→` | Normal | Switch focus between split windows |
| `Ctrl + Shift + ↑/↓/←/→` | Normal | Move split window position |

### 2. Tab & Buffer Navigation (Browser Style)
| Keymap | Mode | Description |
| --- | --- | --- |
| `Ctrl + Tab` / `Ctrl + PageDown` | Normal, Insert, Visual | Go to next tab/buffer |
| `Ctrl + Shift + Tab` / `Ctrl + PageUp` | Normal, Insert, Visual | Go to previous tab/buffer |
| `Ctrl + Alt + →` / `Ctrl + Tab` | Insert, Visual, Terminal | Go to next tab/buffer |
| `Ctrl + Alt + ←` / `Ctrl + Shift + Tab` | Insert, Visual, Terminal | Go to previous tab/buffer |

### 3. Editing & Selection (Linux/Windows Style)
| Keymap | Mode | Description |
| --- | --- | --- |
| `Ctrl + c` | Visual | Copy selection to system clipboard |
| `Ctrl + x` | Visual | Cut selection to system clipboard |
| `Ctrl + v` | Normal, Insert, Visual | Paste from system clipboard |
| `Ctrl + z` / `Ctrl + y` | All | Undo / Redo |
| `Ctrl + Backspace` | Normal, Insert | Delete word backward |
| `Ctrl + H` | Normal, Insert | Delete to start of line |
| `Ctrl + Delete` | Normal, Insert | Delete word forward |
| `Ctrl + a` | All | Select all text (`ggVG`) |
| `Ctrl + Left` / `Ctrl + Right` | Normal, Visual | Go to start/end of line (`^` / `$`) |
| `Ctrl + Left` / `Ctrl + Right` | Insert | Go to start/end of line (`Home` / `End`) |
| `Alt + ←` / `Alt + →` | All | Move cursor word-by-word left / right |
| `Ctrl + Enter` | Normal, Insert | Create new line below |
| `Shift + Enter` | Normal, Insert | Add semicolon (`;`) to the end of the line |
| `Alt + ↑` / `Alt + ↓` | All | Move active line(s) up / down |
| `Shift + Alt + ↑/↓` | All | Duplicate line(s) up / down |
| `Tab` / `Shift + Tab` | Normal, Visual | Indent / Outdent line or selection |
| `Ctrl + Shift + k` | Normal, Insert | Delete active line |

### 4. Search, Replace & Multi-Cursor
| Keymap | Mode | Description |
| --- | --- | --- |
| `Ctrl + d` | Normal, Visual, Select | Add cursor to next occurrence of selected word (VS Code style) |
| `Ctrl + Shift + l` | Normal, Visual, Select | Select all occurrences of the active word in the document |
| `Ctrl + p` | All | Search files (Telescope `find_files`) |
| `Ctrl + f` | Normal, Visual, Select | Find in active file (Telescope `current_buffer_fuzzy_find`) |
| `Ctrl + Shift + f` | All | Find in project / Global grep (Telescope `live_grep`) |
| `Ctrl + h` | Normal, Visual | Open Search and Replace line command (`:%s/` or `:s/`) |

### 5. UI, Scroll, and Comments
| Keymap | Mode | Description |
| --- | --- | --- |
| `Ctrl + /` / `Ctrl + _` | All | Toggle comment on line or selection |
| `Ctrl + g` | All | Jump to line number |
| `Ctrl + [` / `Ctrl + ]` | Normal | Go backward / forward in cursor jump history |
| `K` / `I` | Normal | Scroll view viewport down / up by 3 lines |
| `Shift + ScrollWheel` | All | Horizontal scroll (left/right) with cursor jump point saving |

### 6. Tools & AI Agent Integrations
| Keymap | Mode | Description |
| --- | --- | --- |
| `Ctrl + b` | All | Toggle File Explorer (NvimTree) |
| `Alt + e` | Normal, Terminal | Toggle Floating Terminal |
| `Ctrl + l` | All | Toggle **Antigravity AI Agent CLI** (`agy`) panel on the right (30% width) |
| `Ctrl + Shift + g` | All | Toggle **Neogit** (VS Code Git GUI) panel on the right (30% width) |
| `<leader>gg` | Normal | Open interactive **GitGraph** (visualize commits) |
| `<leader>p` | Normal | Open visual terminal preview of the image under cursor (via **Chafa**) |

### 7. LSP (Language Server Protocol) Actions
| Keymap | Mode | Description |
| --- | --- | --- |
| `F12` / `Ctrl + LeftClick` | All | Go to Definition (or search references if already at definition) |
| `Shift + F12` | Normal | Find references |
| `Ctrl + Shift + i` / `Alt + Shift + f` | All | Format active document |
| `F2` | Normal | Rename symbol globally |
| `Ctrl + .` | All | Trigger Code Action |

---

## 🎨 Neovide Configuration

If you run the editor inside **Neovide** on Linux, specific visual improvements are loaded automatically in [lua/options.lua](file:///Users/dionovan/project/portfolio/dotfiles/nvim/lua/options.lua):
- **Font**: Set to standard Nerd Font config with custom line spacing (`linespace`) set to `14`.
- **Visuals**: Background opacity is set to `0.9` with background blurring enabled (`neovide_window_blurred = true`).
- **Animations**: Cursor transition length is set to `0.13` seconds with cursor trails set to `0.8`. Smooth scroll animation length is set to `0.08` seconds for maximum responsiveness.

---

## 📂 Configuration Layout

```text
nvim/
├── init.lua               # Config entry point (bootstrapping lazy & loading components)
├── lazy-lock.json         # Pinned versions of Neovim plugins
├── .stylua.toml           # Formatting settings for StyLua
├── LICENSE                # License information
└── lua/
    ├── options.lua        # General Vim and Neovide UI settings
    ├── mappings.lua       # Comprehensive VS Code/Linux-style shortcuts
    ├── autocmds.lua       # Auto-commands (image preview, reload files, terminal insertion)
    ├── chadrc.lua         # Core NvChad theme options (Gruvbox base46 customization)
    ├── tabufline_custom.lua # Tabline custom styling (Git & LSP indicators)
    ├── configs/
    │   ├── lazy.lua       # Performance configuration for lazy.nvim
    │   ├── lspconfig.lua  # Language Server configs (Emmet, Eslint, Tailwind, ts_ls)
    │   └── conform.lua    # Formatter parameters (Stylua, Prettier)
    └── plugins/
        └── init.lua       # Third-party plugin installation settings (Ctrl multi-cursor)
```

---

## 💳 Credits & References

1. [LazyVim Starter](https://github.com/LazyVim/starter) - Design structure inspiration.
2. [NvChad](https://github.com/NvChad/NvChad) - Base Neovim framework providing the core UI and plugin structure.
