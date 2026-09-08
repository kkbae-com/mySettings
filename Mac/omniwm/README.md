# OmniWM Configuration (Planned)

**Tool:** [OmniWM](https://omniwm.app/) - a Niri/Hyprland-inspired tiling window manager, positioned as a yabai/AeroSpace alternative for Apple Silicon Macs

**Status:** Not yet configured. This is a setup plan, to be carried out and turned into a real config on a machine running macOS 26 (Tahoe) - the machine this repo was last worked from is on Sonoma 14.6 and can't run OmniWM.

## Requirements

- macOS 26 (Tahoe) or later, Apple Silicon (no Intel support)
- Homebrew

## Setup Plan (run on the Tahoe machine)

1. Install:
   ```bash
   brew install --cask omniwm
   ```
   Installs `OmniWM.app` plus the `omniwmctl` CLI.

2. Keep AeroSpace from fighting OmniWM for window control - only one tiling WM should be actively running at a time, and it shouldn't be mid-Space-management across the logout/login in the next step:
   ```bash
   aerospace quit   # or: killall AeroSpace
   ```
   Whichever `aerospace-1monitor`/`aerospace-2monitor` package is currently stowed has `start-at-login = true`; flip it to `false` while trialing OmniWM so AeroSpace doesn't relaunch itself, then flip it back if you return to AeroSpace.

3. In System Settings -> Desktop & Dock, turn on **"Displays have separate Spaces"**, then log out and back in - required before first launch.

4. Launch `OmniWM.app` once. Grant **Accessibility** and **Input Monitoring** permissions when prompted. Screen Recording is optional, only needed for the Overview thumbnails feature.

5. Let OmniWM generate its default config at `~/.config/omniwm/settings.toml`, then tune it to taste.

6. Bring the tuned config into this repo:
   ```bash
   cd ~/Projects/mySettings/Mac   # adjust to wherever this repo is cloned on that machine
   mkdir -p omniwm/.config/omniwm
   cp ~/.config/omniwm/settings.toml omniwm/.config/omniwm/settings.toml
   rm ~/.config/omniwm/settings.toml
   stow -t ~ omniwm
   ```
   Removing the original before stowing avoids a "existing target" conflict. (`stow --adopt -t ~ omniwm` pulls the live file into the repo instead, but overwrites the repo copy with whatever's on disk - diff it afterward if you go that route.)

7. Rewrite this README's Status/Features/Configuration Highlights/Dependencies sections to describe the real config, matching the style of `Mac/zsh/README.md` and `Mac/aerospace-1monitor/README.md`, and delete this Setup Plan section.

8. Commit and push from that machine; open a PR (or bring the branch back here) once you've decided whether to keep OmniWM.

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

## Dependencies

- OmniWM (installed via Homebrew Cask)
