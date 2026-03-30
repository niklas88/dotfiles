# 🌙 Neovim Config (0.12+)

A modern, Lua-native Neovim configuration, featuring built-in plugin management,
robust LSP support, and OSC 52 clipboard integration.

## 📦 Plugin Management
This config uses the Neovim 0.12 built-in **`vim.pack`** system. 
- **Location**: Plugins are managed in `~/.local/share/nvim/site/pack/core/opt/`.
- **Lockfile**: `nvim-pack-lock.json` tracks specific revisions for reproducibility.

## ⌨️ Keybindings

The **Leader** key is set to `<Space>`.

### General & Editing
| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlighting (`nohlsearch`) |
| `Y` | Yank to end of line (`y$`) |
| `c` | Change without yanking to default register (`"xc`) |
| `p` (Visual) | Paste without overwriting default register |
| `<` / `>` | Indent/Outdent and keep visual selection |
| `[q` / `]q` | Navigate Quickfix list |

### Navigation & Fuzzy Finder (fzf-lua)
| Key | Action |
|-----|--------|
| `s` | **Leap**: Jump to any character (2-char search) |
| `S` | **Leap**: Jump from another window |
| `<leader>ff` | Search Files |
| `<leader>fg` | Live Grep |
| `<leader>ft` | Search Buffers |
| `<leader>fh` | Search Help Tags |

### Oil (File Navigation)
| Key   | Action |
|-------|--------|
| `-`   | Open parent directory explorer |
| `<CR>`| Open file in a **new tab** |

### LSP (Language Server Protocol)
| Key | Action |
|-----|--------|
| `gd` | Go to Definition |
| `gr` | List References (Quickfix) |
| `K` | Show Hover documentation (Rounded) |
| `sh` | Show Signature Help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code Action |
| `<leader>f` | Format Buffer (via **Conform.nvim**) |
| `<F6>` | Toggle Diagnostics visibility |
| `[d` / `]d` | Navigate Diagnostics |

### Completion
| Key | Action |
|-----|--------|
| `<C-x><C-o>` | Trigger Omni-completion (LSP) |
| `<C-j>` | Next item in completion menu |
| `<C-k>` | Previous item in completion menu |

## 🛠️ Features & Configuration

### 📋 Clipboard (OSC 52)
The configuration uses a dedicated OSC 52 provider for bidirectional clipboard
support. This allows you to copy/paste between Neovim and your System Clipboard
even when working over SSH, provided your terminal supports OSC 52.

### 🎨 Visuals
- **Theme**: Catppuccin Mocha (Transparent background enabled).
- **Statusline**: Lualine with Catppuccin integration and Hostname display.
- **Icons**: Nvim-web-devicons for a rich visual experience.
- **UI**: Rounded borders for LSP hovers, signatures, and diagnostic floats.

### 🚀 LSP Servers
Native support for:
- **C/C++** (`clangd`)
- **Rust** (`rust_analyzer`)
- **Python** (`pyright`)
- **Go** (`gopls`)
- **Bash** (`bashls`)

### 🧼 Formatting (Conform.nvim)
Auto-configured formatters:
- **Python**: black, isort
- **Lua**: stylua
- **Rust/C**: rustfmt / clang-format (with LSP fallback)
- **Web**: djlint (HTML/Jinja), css_beautify, yamlfmt

## 🖥️ GUI (ginit.lua)
Settings for GUI clients (like nvim-qt or goneovim):
- **Font**: BlexMono Nerd Font Medium, size 11.
- **Mouse**: Fully enabled (`a`).
- **Context Menu**: Enabled on Right-Click.
