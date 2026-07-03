# ⚡ Neovim Configuration (NvChad v2.5 Based)

This is a personal Neovim configuration customized from **NvChad v2.5**, specifically tailored for macOS users with **VS Code-style UX** keybindings, native terminal tool integrations, and AI agent assistance.

---

## 🌟 Key Features

1. **Neovide Optimized**: Pre-configured options for the Neovide GUI (including `MesloLGS Nerd Font Mono` at size 14, linespace 14, 0.9 window transparency with blur, smooth scrolling, and cursor trail animations).
2. **VS Code & macOS Keybindings**: Common shortcuts like `Cmd + s` (save), `Cmd + c`/`v` (system clipboard integration), `Cmd + z`/`y` (undo/redo), `Alt + Arrow` (word-by-word movement), and line duplications.
3. **Multi-Cursor Editing (`vim-visual-multi`)**: Press `Cmd + d` to select matching words one by one (VS Code behavior) and `Cmd + Shift + l` to select all occurrences in the document.
4. **Image & Hover Previews**:
   - Intercepts image files (`.png`, `.jpg`, etc.) opened in Neovim and renders them directly inside a floating terminal using **Chafa**.
   - Auto hover previews: hovering the cursor over an image path automatically spawns a preview window (which automatically closes when the cursor moves).
   - Manual preview with `<leader>p` for image path under cursor or file selected in NvimTree.
5. **Robust Git Integration**:
   - **Neogit**: Interactive git panel mimicking VS Code source control panel (`Cmd + Shift + g`).
   - **GitGraph**: Draw interactive Git commit trees visually inside a buffer (`<leader>gg`). Pressing Enter on a commit opens the diff view.
   - **Diffview**: Comprehensive git diff viewer.
   - **Gitsigns**: In-buffer signs and virtual blame text at the end of the line (EOL) with a 500ms delay.
6. **Custom Tabufline**: Fully customized buffer tabline that dynamically colors buffer tabs based on Diagnostic Errors (red font) and Git Signs (added/changed/removed). It also displays unique paths (e.g. `parent_dir/filename`) if multiple files share the same filename.
7. **Breadcrumbs / Sticky Winbar**: Code structure navigation at the top of the editor window via `dropbar.nvim`.
8. **Antigravity AI Assistant (`agy`)**: Seamlessly open/close the **Antigravity AI Agent CLI** inside a 30% split pane on the right side using the `Cmd + l` keymap.
9. **Auto-Format on Save**: Documents are automatically formatted upon saving using `conform.nvim` (utilizes Prettier for JS, TS, HTML, CSS, JSON, Markdown, and StyLua for Lua configurations).
10. **LSP & Autocomplete**: Modern LSP client settings with custom configurations for `html`, `cssls`, `ts_ls` (TypeScript), `tailwindcss`, `eslint`, `emmet_language_server`, and `prismals`. Autocomplete uses `nvim-cmp` with confirmation on `<Tab>` and navigation using arrow keys.

---

## 📋 System Prerequisites & External Dependencies

To get the full experience and avoid errors, make sure you have the following external dependencies installed on your system:

### 1. Neovim (v0.10+)
Required for modern API features and compatibility with plugins like lazy.nvim, dropbar.nvim, etc.
- **macOS (Homebrew)**: `brew install neovim`
- **Linux (Ubuntu/Debian)**: `sudo apt install neovim` (or compile from source/use AppImage for v0.10+)

### 2. Antigravity CLI (`agy`) — *CRITICAL for AI Agent Panel*
The configuration includes a custom command toggle (`Cmd + l`) to open the Antigravity AI Agent CLI directly in a Neovim split pane.
* **macOS / Linux**:
  ```bash
  curl -fsSL https://antigravity.google/cli/install.sh | bash
  ```
* **Windows (PowerShell)**:
  ```powershell
  irm https://antigravity.google/cli/install.ps1 | iex
  ```
* **Windows (CMD)**:
  ```cmd
  curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd
  ```

> [!IMPORTANT]
> **Authentication & Path Settings**:
> 1. On first installation, you should run `agy` in your terminal to complete the interactive setup and authentication process.
> 2. The Neovim configuration is currently hardcoded to run the `agy` binary located at `/Users/dionovan/.local/bin/agy`. If your binary is installed elsewhere (e.g. `~/.local/bin/agy` for a different user), you will need to update the path inside [lua/mappings.lua](file:///Users/dionovan/project/portfolio/dotfiles/nvim/lua/mappings.lua#L501).

### 3. Chafa — *Required for Image Previewing*
Renders images directly in your terminal. Required for the hover preview and image buffer interceptor.
- **macOS**: `brew install chafa`
- **Linux (Ubuntu/Debian)**: `sudo apt install chafa`
- **Arch Linux**: `sudo pacman -S chafa`

### 4. Nerd Font (Icon Pack)
Required for rendering editor, git, and language icons correctly.
- Recommended: **MesloLGS Nerd Font Mono** (hardcoded in Neovide font configuration). You can download it from [Nerd Fonts](https://www.nerdfonts.com/font-downloads).

### 5. Git
Required for plugin package managers (lazy.nvim) and interactive git clients (Neogit/GitGraph).
- **macOS**: Installed by default or via `brew install git`.

### 6. Node.js & npm / yarn
Required for Mason to install and run Language Servers (LSP) and formatters (like Prettier).
- **macOS**: `brew install node`

### 7. Neovide (Optional GUI)
If you prefer running Neovim as a desktop GUI app, Neovide is highly recommended.
- **macOS**: `brew install --cask neovide`

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

Keybindings are configured to match standard macOS and VS Code shortcuts, utilizing the Command key (`<D-...>` in macOS configuration).

### 1. File & Buffer Operations
| Keymap | Mode | Description |
| --- | --- | --- |
| `Cmd + s` | Normal, Insert, Visual | Save active file (`:w`) |
| `Cmd + n` | Normal, Insert, Visual | Create a new file/buffer |
| `Cmd + w` or `Cmd + F4` | Normal, Insert, Visual | Close active buffer / tab |
| `Cmd + \` | Normal, Insert, Visual | Split window vertically |
| `Cmd + Shift + \` | Normal, Insert, Visual | Split window horizontally |
| `Cmd + Ctrl + ↑/↓/←/→` | Normal | Switch focus between split windows |
| `Cmd + Shift + ↑/↓/←/→` | Normal | Move split window position |

### 2. Tab & Buffer Navigation (Browser Style)
| Keymap | Mode | Description |
| --- | --- | --- |
| `Cmd + Tab` / `Cmd + PageDown` | Normal, Insert, Visual | Go to next tab/buffer |
| `Cmd + Shift + Tab` / `Cmd + PageUp` | Normal, Insert, Visual | Go to previous tab/buffer |
| `Cmd + Alt + →` / `Ctrl + Tab` | All | Go to next tab/buffer |
| `Cmd + Alt + ←` / `Ctrl + Shift + Tab` | All | Go to previous tab/buffer |

### 3. Editing & Selection (macOS Style)
| Keymap | Mode | Description |
| --- | --- | --- |
| `Cmd + c` | Visual | Copy selection to system clipboard |
| `Cmd + x` | Visual | Cut selection to system clipboard |
| `Cmd + v` | Normal, Insert, Visual | Paste from system clipboard |
| `Cmd + z` / `Cmd + y` | All | Undo / Redo |
| `Alt + Backspace` | Normal, Insert | Delete word backward |
| `Cmd + Backspace` | Normal, Insert | Delete to start of line |
| `Cmd + Delete` | Normal, Insert | Delete word forward |
| `Cmd + a` | All | Select all text (`ggVG`) |
| `Cmd + ←` / `Cmd + →` | Normal, Visual | Go to start/end of line (`^` / `$`) |
| `Cmd + ←` / `Cmd + →` | Insert | Go to start/end of line (`Home` / `End`) |
| `Alt + ←` / `Alt + →` | All | Move cursor word-by-word left / right |
| `Cmd + Enter` | Normal, Insert | Create new line below |
| `Shift + Enter` | Normal, Insert | Add semicolon (`;`) to the end of the line |
| `Alt + ↑` / `Alt + ↓` | All | Move active line(s) up / down |
| `Shift + Alt + ↑/↓` | All | Duplicate line(s) up / down |
| `Tab` / `Shift + Tab` | Normal, Visual | Indent / Outdent line or selection |
| `Cmd + Shift + k` | Normal, Insert | Delete active line |

### 4. Search, Replace & Multi-Cursor
| Keymap | Mode | Description |
| --- | --- | --- |
| `Cmd + d` | Normal, Visual, Select | Add cursor to next occurrence of selected word (VS Code style) |
| `Cmd + Shift + l` | Normal, Visual, Select | Select all occurrences of the active word in the document |
| `Cmd + p` | All | Search files (Telescope `find_files`) |
| `Cmd + f` | Normal, Visual, Select | Find in active file (Telescope `current_buffer_fuzzy_find`) |
| `Cmd + Shift + f` | All | Find in project / Global grep (Telescope `live_grep`) |
| `Cmd + h` | Normal, Visual | Open Search and Replace line command (`:%s/` or `:s/`) |

### 5. UI, Scroll, and Comments
| Keymap | Mode | Description |
| --- | --- | --- |
| `Cmd + /` / `Cmd + _` | All | Toggle comment on line or selection |
| `Cmd + g` | All | Jump to line number |
| `Cmd + [` / `Cmd + ]` | Normal | Go backward / forward in cursor jump history |
| `K` / `I` | Normal | Scroll view viewport down / up by 3 lines |
| `Shift + ScrollWheel` | All | Horizontal scroll (left/right) with cursor jump point saving |

### 6. Tools & AI Agent Integrations
| Keymap | Mode | Description |
| --- | --- | --- |
| `Cmd + b` | All | Toggle File Explorer (NvimTree) |
| `Alt + e` | Normal, Terminal | Toggle Floating Terminal |
| `Cmd + l` | All | Toggle **Antigravity AI Agent CLI** (`agy`) panel on the right (30% width) |
| `Cmd + Shift + g` | All | Toggle **Neogit** (VS Code Git GUI) panel on the right (30% width) |
| `<leader>gg` | Normal | Open interactive **GitGraph** (visualize commits) |
| `<leader>p` | Normal | Open visual terminal preview of the image under cursor (via **Chafa**) |

### 7. LSP (Language Server Protocol) Actions
| Keymap | Mode | Description |
| --- | --- | --- |
| `F12` / `Cmd + LeftClick` | All | Go to Definition (or search references if already at definition) |
| `Shift + F12` | Normal | Find references |
| `Cmd + Shift + i` / `Alt + Shift + f` | All | Format active document |
| `F2` | Normal | Rename symbol globally |
| `Cmd + .` | All | Trigger Code Action |

---

## 🎨 Neovide Configuration

If you run the editor inside **Neovide**, specific visual improvements are loaded automatically in [lua/options.lua](file:///Users/dionovan/project/portfolio/dotfiles/nvim/lua/options.lua):
- **Font**: Set to `MesloLGS Nerd Font Mono:h14` with a custom height/spacing (`linespace`) set to `14` for coding comfort.
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
    ├── mappings.lua       # Comprehensive VS Code/macOS-style shortcuts
    ├── autocmds.lua       # Auto-commands (image preview, reload files, terminal insertion)
    ├── chadrc.lua         # Core NvChad theme options (Gruvbox base46 customization)
    ├── tabufline_custom.lua # Tabline custom styling (Git & LSP indicators)
    ├── configs/
    │   ├── lazy.lua       # Performance configuration for lazy.nvim
    │   ├── lspconfig.lua  # Language Server configs (Emmet, Eslint, Tailwind, ts_ls)
    │   └── conform.lua    # Formatter parameters (Stylua, Prettier)
    └── plugins/
        └── init.lua       # Third-party plugin installation settings
```

---

## 💳 Credits & References

1. [LazyVim Starter](https://github.com/LazyVim/starter) - Design structure inspiration.
2. [NvChad](https://github.com/NvChad/NvChad) - Base Neovim framework providing the core UI and plugin structure.
