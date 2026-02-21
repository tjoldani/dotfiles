# Claude Code Configuration for /home/tj

## Overview

This is the home directory for a highly customized Arch Linux development environment with:
- **Primary Shell**: Fish (with Bash fallback)
- **Window Manager**: Hyprland (Wayland-native tiling WM)
- **Primary Editor**: Neovim with extensive LSP/plugin setup
- **Terminal**: Kitty with Tokyo Night theme
- **Dotfiles**: Managed via bare git repository at `~/.dotfiles/`
- **Knowledge Base**: Obsidian vault at `~/Documents/Home/` using PARA method

## Primary Focus Areas

When working in this directory, prioritize:

1. **Dotfiles and System Configuration** - Managing configuration files across `.config/` directories
2. **Obsidian Vault Management** - Working with notes, templates, and knowledge organization
3. **Development Projects** - Occasional coding work in various languages

## Critical Guidelines

### Configuration File Changes

**IMPORTANT**: Always ask before editing configuration files. This user values stability and wants to review changes before they're applied.

**Extra caution required for**:
- **Hyprland configs** (`~/.config/hypr/`) - These control the entire desktop environment
  - Changes here can break window management, keybindings, or the whole desktop session
  - Test changes carefully and ensure no syntax errors
  - Never remove critical autostart programs (waybar, mako, hypridle, hyprpaper)

**Other critical configs to handle carefully**:
- Neovim plugins/LSP (`~/.config/nvim/`)
- Shell configs (`~/.config/fish/config.fish`)
- Custom scripts (`~/.local/bin/`)
- Tmux configuration (`~/.config/tmux/tmux.conf`)

### Dotfiles Repository Workflow

Configuration files are version-controlled via a bare git repository:
- **Repo location**: `~/.dotfiles/` (bare repo)
- **Remote**: `git@github.com:tjoldani/dotfiles.git`
- **Managed via alias**: `dotfiles` command (special git alias in Fish)
- **Tracked directories**: `.config/{fish,ghostty,hypr,kitty,nvim,waybar,wlogout,wofi,tmux,mako}`, `.local/bin/`

**When making config changes**:
1. Ask before editing any configuration file
2. After editing, ask before committing to dotfiles repo
3. Use the `dotfiles` alias for git operations, not regular `git`
4. Alternative: User has `update-git.sh` script for auto-committing dotfiles

**Example dotfiles workflow**:
```bash
# Check status
dotfiles status

# Add and commit
dotfiles add .config/hypr/hyprland.conf
dotfiles commit -m "update hyprland keybindings"

# Push to remote
dotfiles push
```

## Code Style Preferences

- **Minimal and clean**: Prefer simple, readable solutions without over-engineering
- **Modern best practices**: Use current standards and modern language features
- **Follow existing patterns**: Match the style already present in configs and code
- **No unnecessary additions**: Don't add features, comments, or abstractions unless needed

## Development Environment

### Languages and Tools

**Installed runtimes**:
- Python 3.14.3 (with IPython)
- Node.js v25.6.1 (managed via NVM)
- Go 1.26.0
- Git 2.53.0

**Package managers**:
- npm (Node.js)
- pip (Python)
- nvm (Node version management)
- yay (Arch AUR helper)

### Editor Setup

**Neovim** (`~/.config/nvim/`):
- Leader key: `Space`
- Plugin manager: Lazy.nvim
- LSP: Mason with auto-install for language servers
- Completion: blink.cmp
- File navigation: Snacks.nvim picker
- Theme: Tokyo Night
- Modular Lua config structure

**Language support in Neovim**:
| Language | LSP | Linter | Formatter |
|----------|-----|--------|-----------|
| JavaScript/TypeScript | typescript-language-server | eslint_d | prettier |
| Python | pyright | ruff | ruff_format |
| Lua | lua-language-server | - | stylua |
| HTML | html-lsp | htmlhint | prettier |
| CSS/SCSS | css-lsp | - | prettier |
| YAML | yaml-language-server | yamllint | prettier |
| Markdown | marksman | markdownlint-cli2 | prettier |
| Bash | bash-language-server | - | - |

### Terminal and Shell

**Fish Shell** (`~/.config/fish/config.fish`):
- Quick aliases: `v` (nvim), `vv` (nvim .), `py` (python3), `ll` (ls -la)
- Config edit shortcuts: `vh` (Hyprland), `vn` (Neovim), `vf` (Fish)
- Git workflow alias: `gp` (add, commit, push in one command)
- Integration: nvm.fish, fzf, yazi file manager

**Environment variables**:
- `EDITOR`: /usr/bin/nvim
- `BROWSER`: /usr/bin/librewolf
- `TERMINAL`: /usr/bin/kitty
- Wayland-optimized for Electron apps

**Tmux** (`~/.config/tmux/tmux.conf`):
- Prefix: `Ctrl+Space` (not default Ctrl+B)
- Vim-style navigation: `h/j/k/l` for panes
- Auto-restore sessions via tmux-resurrect
- Theme: Tokyo Night

### Hyprland Window Manager

**Config**: `~/.config/hypr/hyprland.conf`

**Key keybindings** (Super = Windows/Command key):
- `Super+Return`: Terminal (Kitty)
- `Super+Q`: Kill active window
- `Super+Space`: Application menu (wofi)
- `Super+O`: Open Obsidian
- `Super+B`: Open browser
- `Super+E`: File manager
- `Super+H/J/K/L`: Move focus (Vi-style)
- `Super+1-9`: Switch workspaces
- `Super+N`: Toggle notes workspace (Obsidian)
- `Super+S`: Toggle scratch workspace
- `Super+Alt+N`: New note script
- `Super+Alt+D`: Daily note script

**Special workspaces**:
- Workspace 1: Terminal (auto-start)
- Workspace 4: Browser (auto-start)
- special:notes: Obsidian vault
- special:scratch: Spotify

## Obsidian Vault

**Location**: `~/Documents/Home/`

**Organization**: PARA method
- `00 Inbox/` - Quick captures and unprocessed notes
- `01 Daily/` - Daily notes organized by year/month
- `02 Projects/` - Active project notes
- `03 Areas/` - Ongoing areas of responsibility
- `04 Resources/` - Reference materials
- `05 Archive/` - Completed/inactive items

**Key features**:
- Git integration via Obsidian Git plugin
- Templater for dynamic templates
- Vim mode enabled
- Custom scripts for note creation in `~/.local/bin/`

**Note creation scripts**:
- `dailynote.sh` - Creates daily notes with special prompts for Monday (standup) and Friday (reflection)
- `newnote.sh` - Creates quick notes in Inbox with timestamp

**For Obsidian-specific guidance**, refer to: `~/Documents/Home/CLAUDE.md`

## Custom Scripts

**Location**: `~/.local/bin/` (in PATH)

- `dailynote.sh` - Daily note creation for Obsidian
- `newnote.sh` - Quick note creation for Obsidian
- `update-git.sh` - Auto-commit and push dotfiles

These scripts are part of the daily workflow - be careful when modifying them.

## Theme and Appearance

**Consistent theme**: Tokyo Night across all tools
- Neovim colorscheme
- Kitty terminal theme
- Tmux theme
- GTK theme (Tokyonight-Dark)

**Font**: MesloLGDZ at 13pt

## Git Configuration

- **User**: tjoldani
- **Email**: 165098448+tjoldani@users.noreply.github.com
- **SSH**: Uses SSH for GitHub authentication

## Project Locations

- `~/Projects/` - General development projects (currently empty)
- `~/Downloads/HA/` - Home Assistant related project (git repo)
- `~/Documents/Home/` - Obsidian vault (git-backed)

## Best Practices When Assisting

1. **Read before editing**: Always read config files before suggesting changes
2. **Ask before modifying**: Especially for Hyprland, Neovim, and shell configs
3. **Test suggestions**: Ensure config syntax is valid (especially for Lua, Fish, Hyprland)
4. **Follow existing patterns**: Match the user's existing config style and structure
5. **Preserve theme consistency**: Maintain Tokyo Night theme when adding new tools
6. **Respect dotfiles workflow**: Remember configs are version-controlled
7. **Use existing tools**: Don't suggest installing new tools when existing ones suffice
8. **Stay minimal**: Don't over-engineer or add unnecessary complexity

## Common Tasks

### Editing configs
- Always ask before editing
- Use Neovim for editing: `nvim ~/.config/path/to/config`
- Test changes before committing to dotfiles

### Working with Obsidian
- Refer to `~/Documents/Home/CLAUDE.md` for vault-specific instructions
- Use existing scripts for note creation
- Respect PARA organization method

### Development work
- Use appropriate language servers (already configured)
- Follow formatter settings (prettier, ruff, stylua)
- Respect ESLint configuration for JavaScript

### System configuration
- Extra careful with Hyprland - test before committing
- Reload configs when possible rather than restarting
- Check Hyprland docs before adding new features

## Useful Commands

```bash
# Reload Hyprland config
hyprctl reload

# Reload Waybar
killall waybar && waybar &

# Reload Fish config
source ~/.config/fish/config.fish

# Tmux reload
tmux source ~/.config/tmux/tmux.conf

# Neovim - use :Lazy sync inside editor to update plugins

# Dotfiles management
dotfiles status
dotfiles add <file>
dotfiles commit -m "message"
dotfiles push
```

## Notes

- This user values a keyboard-driven, terminal-centric workflow
- Vim keybindings are preferred throughout (Neovim, Tmux, Hyprland navigation)
- Wayland-first setup - use Wayland-compatible tools
- Minimalist approach - don't add unnecessary features or complexity
- Strong emphasis on knowledge management and documentation via Obsidian
