# AeroSpace Configuration (Single Monitor)

**Tool:** [AeroSpace](https://github.com/nikitabobko/AeroSpace) - A tiling window manager for macOS

**Setup:** Single monitor (Built-in Display)

## Files

- `.aerospace.toml` - Main configuration file for AeroSpace window manager
- `.config/aerospace/new_ghostty.sh` - Helper script for spawning new Ghostty terminal windows

## Features

- Tiling window management for macOS
- Keyboard-driven window control
- Optimized for single monitor setup
- All workspaces (1-5) assigned to Built-in Display
- Customizable gaps and layouts

## Installation

1. Install AeroSpace:
   ```bash
   brew install --cask aerospace
   ```

2. Deploy configuration:
   ```bash
   cd ~/Documents/Projects/kkbae/mySettings/Mac
   stow --no-folding -t ~ aerospace-1monitor
   ```

   **Note:** If you're switching from the 2-monitor configuration, remove it first:
   ```bash
   stow -D -t ~ aerospace-2monitor
   stow --no-folding -t ~ aerospace-1monitor
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

## Dependencies

- AeroSpace (installed via Homebrew Cask)
- Ghostty terminal (for new_ghostty.sh script)
