# Zellij Configuration

**Tool:** [Zellij](https://zellij.dev/) - Terminal workspace manager

## Files

- `.config/zellij/config.kdl` - Main Zellij configuration with custom keybindings

## Features

- Custom keybindings (clears defaults)
- Vim-style navigation (hjkl)
- Pane management (split, float, focus)
- Tab management with numbered shortcuts
- Modal keybinding system (locked, pane, tab, resize, etc.)

## Installation

1. Install Zellij:
   ```bash
   brew install zellij
   ```

2. Deploy configuration:
   ```bash
   cd ~/Documents/Projects/kkbae/mySettings/Mac
   stow --no-folding -t ~ zellij
   ```

3. Restart Zellij or start a new session

## Starting a session

Zellij does **not** auto-start with the shell - most shells don't need a session,
so it's started on demand:

```bash
zellij                      # new session
zellij attach -c main       # attach to a session named "main", creating it if absent
zellij ls                   # list running sessions
```

To auto-start it on every new shell instead, uncomment the
`zellij setup --generate-auto-start zsh` line in `Mac/zsh/.zshrc` - or copy that
line into `~/.zshrc.local` to enable it on one machine only. Two env vars pair
with it: `ZELLIJ_AUTO_ATTACH=true` reuses an existing session rather than opening
a new one each time, and `ZELLIJ_AUTO_EXIT=true` closes the shell when you detach.

## Configuration Highlights

- **Clear defaults:** All default keybindings removed for custom setup
- **Mode switching:** Ctrl+g to return to normal mode
- **Vim-style:** hjkl for navigation
- **Quick tabs:** Number keys (1-9) to switch tabs
- **Pane splits:** d (down), r (right), n (new)
- **Focus:** Toggle fullscreen, floating panes, and more

## Keybinding Modes

The config defines custom keybindings for:
- `locked` - Locked mode (Ctrl+g to unlock)
- `pane` - Pane management
- `tab` - Tab management
- `resize` - Pane resizing
- `move` - Moving panes
- `scroll` - Scrollback navigation
- `session` - Session management
- `tmux` - Tmux compatibility mode

## Dependencies

- Zellij (installed via Homebrew)

## Notes

- Auto-start in zsh is available but commented out in `.zshrc` - see
  [Starting a session](#starting-a-session)
- Uses KDL (KDL Document Language) for configuration
