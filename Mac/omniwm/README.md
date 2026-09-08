# OmniWM Configuration

**Tool:** [OmniWM](https://omniwm.app/) - a Niri/Hyprland-inspired tiling window manager, positioned as a yabai/AeroSpace alternative for Apple Silicon Macs

**Status:** Configured and stowed. Trialed as an AeroSpace alternative on macOS 26 (Tahoe), Apple Silicon.

## Files

- `.config/omniwm/settings.toml` - Main configuration file for OmniWM

## Features

- Tiling window management for macOS, switchable per-workspace between two layout engines:
  - **niri** - scrollable columns on an infinite horizontal strip
  - **dwindle** - Hyprland-style BSP (binary space partitioning), current default
- 9 workspaces, 7 on the main display and 2 (workspaces 6 and 7) on the secondary display
- Per-app minimum window size rules for commonly used apps
- Quake-style drop-down terminal with blur and transparency
- Per-display workspace bar that overlaps the menu bar and splits around the notch
- Keyboard-driven focus, window movement, and column movement, all trackpad-gesture aware

## Requirements

- macOS 26 (Tahoe) or later, Apple Silicon (no Intel support)
- Homebrew

## Installation

1. **Install OmniWM:**
   ```bash
   brew install --cask omniwm
   ```
   Installs `OmniWM.app` plus the `omniwmctl` CLI.

2. **If migrating from AeroSpace**, quit it first so the two tiling WMs don't fight over window control:
   ```bash
   aerospace quit   # or: killall AeroSpace
   ```
   If `start-at-login = true` is set in whichever `aerospace-1monitor`/`aerospace-2monitor` package is stowed, flip it to `false` so AeroSpace doesn't relaunch itself. Flip it back if you return to AeroSpace later (see [Switching back to AeroSpace](#switching-back-to-aerospace)).

3. **Enable separate Spaces per display:** in System Settings -> Desktop & Dock, turn on **"Displays have separate Spaces"**, then log out and back in. This is required before OmniWM's first launch.

4. **Launch `OmniWM.app` once.** Grant **Accessibility** and **Input Monitoring** permissions when prompted (Screen Recording is optional, only needed for the Overview thumbnails feature). This generates a default config at `~/.config/omniwm/settings.toml`.

5. **Deploy this repo's configuration over the default one:**
   ```bash
   cd ~/Projects/mySettings/Mac
   rm ~/.config/omniwm/settings.toml   # avoids a stow "existing target" conflict
   stow -t ~ omniwm
   ```

6. **Reload OmniWM** (quit and relaunch, or via `omniwmctl` - check `omniwmctl --help` for a reload subcommand) so it picks up the stowed config.

## Switching back to AeroSpace

```bash
cd ~/Projects/mySettings/Mac
stow -D -t ~ omniwm            # if omniwm's config was stowed
# quit OmniWM from its menu bar icon, or via omniwmctl - check `omniwmctl --help`
# for the exact quit/reload subcommand, upstream docs don't pin it down as of this writing
stow -t ~ aerospace-1monitor    # or aerospace-2monitor
aerospace reload-config
```
Set `start-at-login = true` back in the aerospace config once you're back on it full time.

## Configuration Highlights

- **Default layout:** dwindle (BSP), set both globally and per-workspace
- **Layout toggle:** `Option+Shift+L` switches the current workspace between niri and dwindle
- **Borders:** enabled, width 2, dark blue focus indicator
- **Gaps:** none (inner and outer gap size 0)
- **Workspace bar:** overlaps the menu bar (`position = "overlappingMenuBar"`), splits around the notch to the left (`notchMode = "splitActiveLeft"`)
- **Quake terminal:** `Option+\`` toggles it; centered, 50% width/height, standard blur with `opacity = 0.7`
- **Gestures:** 3-finger trackpad, scroll-to-resize on `Option+Shift`, workspace swipe disabled
- **Key hotkeys:**
  - `Option+Arrow` - focus window in direction
  - `Option+Shift+Arrow` - move window in direction
  - `Control+Option+Shift+Arrow` - move column in direction (niri)
  - `Option+1`-`9` / `Option+Shift+1`-`9` - switch to / move window to workspace
  - `Option+Shift+O` - toggle Overview
  - `Control+Option+Space` - open command palette

## Dependencies

- OmniWM (installed via Homebrew Cask)
