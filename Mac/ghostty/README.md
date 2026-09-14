# Ghostty Configuration

**Tool:** [Ghostty](https://ghostty.org/) - A fast, native, feature-rich terminal emulator

## Files

- `Library/Application Support/com.mitchellh.ghostty/config` - Main Ghostty configuration file
- `bin/ghostty++` - AppleScript to open new Ghostty window

## Features

- Terminal emulator configuration
- Custom keybindings, fonts, and themes
- Performance-optimized settings

## Installation

1. Install Ghostty:
   ```bash
   brew install --cask ghostty
   ```

2. Deploy configuration:
   ```bash
   cd ~/Documents/Projects/kkbae/mySettings/Mac
   stow -t ~ ghostty
   ```

3. Restart Ghostty or reload config (Cmd + Shift + ,)

## ghostty++ Script

The `ghostty++` script is an AppleScript helper that:
- Opens a new Ghostty window if the app is already running
- Activates Ghostty if it's not running
- Useful for keybindings with window managers like AeroSpace

### Usage

```bash
~/bin/ghostty++
```

Or bind it to a keyboard shortcut in your window manager.

## Dependencies

- Ghostty (installed via Homebrew Cask)
