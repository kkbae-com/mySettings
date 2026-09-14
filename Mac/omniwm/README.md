# OmniWM Configuration

**Tool:** [OmniWM](https://omniwm.app/) - a Niri/Hyprland-inspired tiling window manager, positioned as a yabai/AeroSpace alternative for Apple Silicon Macs

**Status:** Configured and stowed. Trialed as an AeroSpace alternative on macOS 26 (Tahoe), Apple Silicon.

## Files

- `.config/omniwm/settings.toml` - Main configuration file for OmniWM
- `.config/omniwm/sidecar-workspace-fixup.sh` - Nudges workspaces onto the right monitor when the Sidecar iPad connects (see "Sidecar workspace fixup" below)
- `Library/LaunchAgents/com.mysettings.omniwm-sidecar-watch.plist` - Keeps the above script running on every display change
- `bin/omniwm-display-info` - Prints each active display's UUID and points resolution, for adding new `[[monitorDwindleOverrides]]` entries (see "Adding a monitor override" below)

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
   cd ~/Documents/Projects/kkbae/mySettings/Mac
   rm ~/.config/omniwm/settings.toml   # avoids a stow "existing target" conflict
   stow -t ~ omniwm
   ```

6. **Reload OmniWM** (quit and relaunch, or via `omniwmctl` - check `omniwmctl --help` for a reload subcommand) so it picks up the stowed config.

## Switching back to AeroSpace

```bash
cd ~/Documents/Projects/kkbae/mySettings/Mac
stow -D -t ~ omniwm            # if omniwm's config was stowed
# quit OmniWM from its menu bar icon, or via omniwmctl - check `omniwmctl --help`
# for the exact quit/reload subcommand, upstream docs don't pin it down as of this writing
stow -t ~ aerospace-1monitor    # or aerospace-2monitor
aerospace reload-config
```
Set `start-at-login = true` back in the aerospace config once you're back on it full time.

## Sidecar workspace fixup

`settings.toml` assigns workspaces 1-5 to `main` and 6-9 to `secondary` — the correct split for the HP Z27 setup. OmniWM's static config can't express "secondary, unless the secondary is the Sidecar, in which case main" (only `main`, `secondary`, or a pin to one specific display), so when the Sidecar iPad is connected instead, that same config would put 6-9 on it too instead of the built-in display.

`sidecar-workspace-fixup.sh` works around this: whenever OmniWM fires a `display-changed` IPC event, it checks (`omniwmctl query displays`) whether a Sidecar display is present, and if so nudges workspaces 1-5 onto it and 6-9 back onto the built-in display, using the same temporary runtime override as the in-app "Move Workspace to Monitor" action. It's a no-op when the Sidecar isn't connected. The `left`/`right` directions it uses assume the Sidecar sits physically left of the built-in display in the current routing arrangement - re-check with `omniwmctl query displays --format json` (`frame.x`) if that ever changes.

This requires `ipcEnabled = true` in `settings.toml` (already set) so `omniwmctl` can talk to the running app, and the LaunchAgent to keep a `omniwmctl watch display-changed --reconnect --exec ...` process alive across logins:

```bash
cd ~/Documents/Projects/kkbae/mySettings/Mac
stow -R -t ~ omniwm   # symlinks the script and plist into place
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.mysettings.omniwm-sidecar-watch.plist
```

To stop it: `launchctl bootout gui/$(id -u)/com.mysettings.omniwm-sidecar-watch`. Logs land in `/tmp/omniwm-sidecar-watch.{out,err}.log`.

## Adding a monitor override

Each `[[monitorDwindleOverrides]]` entry in `settings.toml` pins a `singleWindowFit` size to a specific display via `monitorDisplayUUID`. To add one for a new display:

```bash
Mac/omniwm/bin/omniwm-display-info          # all active displays, text output
Mac/omniwm/bin/omniwm-display-info --main   # only the main display
Mac/omniwm/bin/omniwm-display-info --json   # JSON output
```

This prints the display's `id` (CGDirectDisplayID), `uuid` (what goes in `monitorDisplayUUID`), and its logical `points` resolution - the basis for picking a `singleWindowFit` value (existing entries trim a small margin off the full points size, e.g. width/height minus ~60-80px). `monitorName` isn't obtainable this way (CoreGraphics doesn't expose a display's marketing name); set it to whatever label you want to keep the entries readable.

**Caveat:** the UUID `CGDisplayCreateUUIDFromDisplayID` returns for a built-in laptop display is derived from its EDID, which can be identical across separate machines of the same model/panel - it's not guaranteed to be unique per physical device. If a new machine's built-in display reports the same UUID as an existing override entry, don't add a duplicate; decide whether to reuse/rename the existing entry instead.

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
