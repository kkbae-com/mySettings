# AeroSpace Configuration (Dual Monitor)

**Tool:** [AeroSpace](https://github.com/nikitabobko/AeroSpace) - A tiling window manager for macOS

**Setup:** Dual monitor configuration

## Files

- `.aerospace.toml` - Main configuration file for AeroSpace window manager optimized for dual monitors

## Features

- Tiling window management for macOS
- Keyboard-driven window control
- Optimized for dual monitor setup with 9 workspaces
- Workspaces 1-4 assigned to Monitor 1
- Workspaces 5-9 assigned to Monitor 2
- Additional keybindings for multi-monitor navigation
- Customizable gaps and layouts

## Installation

1. Install AeroSpace:
   ```bash
   brew install --cask aerospace
   ```

2. Deploy configuration:
   ```bash
   cd ~/Documents/Projects/kkbae/mySettings/Mac
   stow -t ~ aerospace-2monitor
   ```

   **Note:** If you're switching from the 1-monitor configuration, remove it first:
   ```bash
   stow -D -t ~ aerospace-1monitor
   stow -t ~ aerospace-2monitor
   ```

3. Restart AeroSpace or run:
   ```bash
   aerospace reload-config
   ```

## Configuration Highlights

- **Start at login:** Enabled
- **Default layout:** Tiles
- **Orientation:** Auto (based on monitor aspect ratio)
- **Keyboard layout:** QWERTY
- **Mouse follows focus:** Enabled
- **Workspaces:** 9 total (1-4 on primary, 5-9 on secondary)

## Dual Monitor Keybindings

In addition to standard workspace navigation (alt-1 through alt-9), this configuration includes:

- **alt-ctrl-left/right** - Switch focus between monitors
- **alt-ctrl-shift-left/right** - Move window to adjacent monitor and follow it

## Dependencies

- AeroSpace (installed via Homebrew Cask)
- Ghostty terminal (for terminal launching)

## Switching Between Monitor Configurations

To switch back to single monitor setup:
```bash
cd ~/Documents/Projects/kkbae/mySettings/Mac
stow -D -t ~ aerospace-2monitor
stow -t ~ aerospace-1monitor
aerospace reload-config
```
