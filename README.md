# mySettings

A centralized repository for storing operating system configurations and environment setups across different platforms, managed with GNU Stow.

## Prerequisites

- **GNU Stow** - Required for symlink management
  - macOS: `brew install stow`
  - Linux: `sudo apt install stow` or `sudo yum install stow`
  - Windows: Use WSL or install via Chocolatey: `choco install stow`

## Installation (macOS)

### 1. Install Core Dependencies

```bash
# Install GNU Stow (required for configuration management)
brew install stow

# Install applications and tools
brew install --cask ghostty aerospace  # Terminal emulator and window manager
brew install zellij starship carapace  # Terminal workspace, prompt, and completions
brew install direnv                    # Per-directory environment variables
```

### 2. Clone This Repository

```bash
mkdir -p ~/Documents/Projects/mrcunninghamz
cd ~/Documents/Projects/mrcunninghamz
git clone https://github.com/mrcunninghamz/mySettings.git
cd mySettings
```

### 3. Deploy Configurations

See the [Deploying Configurations](#deploying-configurations) section below for stow usage.

### Package-Specific Dependencies

Each configuration package has its own README with detailed installation instructions:

- **ghostty** - Requires Ghostty terminal emulator (`brew install --cask ghostty`)
- **zsh** - Requires Zellij, Starship, Carapace, direnv, Rust/Cargo, and `postgresql`
  (`brew install postgresql`) - it's keg-only, so `psql`/`pg_restore`/etc. aren't linked
  onto `PATH` by default; `.zshenv` adds `$(brew --prefix postgresql)/bin` explicitly
- **zellij** - Requires Zellij terminal workspace manager (`brew install zellij`)
- **aerospace** - Requires AeroSpace window manager (`brew install --cask aerospace`)
- **git** - No additional dependencies

## Purpose

This repository serves as a version-controlled backup and reference for:
- Configuration files (dotfiles)
- Environment setup scripts
- Tool-specific settings
- Terminal emulator configurations
- Window manager settings
- Shell configurations
- Utility preferences

## Structure

Configuration files are organized by operating system, with each tool/application in its own stow package:

- **Mac/** - macOS configuration packages
- **Windows/** - Windows configuration packages
- **Linux/** - Linux configuration packages

Each package directory mirrors the structure of your home directory. For example:
```
Mac/
├── zsh/
│   ├── .zshrc
│   └── .zshenv
├── vim/
│   └── .vimrc
└── tmux/
    └── .tmux.conf
```

## Status

⚠️ **Work in Progress** - These configurations are actively being developed and refined.

## Usage

### Deploying Configurations

1. Clone this repository (recommended location: `~/Projects/mySettings`)
2. Navigate to your OS-specific folder:
   ```bash
   cd ~/Projects/mySettings/Mac  # or Windows, or Linux
   ```
3. Deploy a specific package with explicit target:
   ```bash
   stow -t ~ zsh         # Creates ~/.zshrc symlink
   stow -t ~ git         # Creates ~/.gitconfig symlink
   ```
4. Deploy all packages:
   ```bash
   stow -t ~ */
   ```

**Note:** The `-t ~` flag explicitly targets your home directory. Without it, stow creates symlinks in the parent directory of where you run it.

### Managing Multiple Configurations for the Same Tool

Some tools may have multiple configuration packages for different setups (e.g., different monitor configurations). In these cases:

1. **Only deploy ONE variant at a time**
2. **Remove the current variant before deploying another**

Example with AeroSpace window manager (1-monitor vs 2-monitor setups):

```bash
# For single monitor setup
stow -t ~ aerospace-1monitor

# To switch to dual monitor setup:
# First, remove the current configuration
stow -D -t ~ aerospace-1monitor

# Then deploy the dual monitor configuration
stow -t ~ aerospace-2monitor
```

**Important:** Never run `stow -t ~ */` if you have multiple variants of the same tool, as this will create conflicts. Deploy packages selectively instead.

### Removing Configurations

```bash
cd ~/Projects/mySettings/Mac
stow -D -t ~ aerospace-1monitor    # Removes aerospace symlinks
stow -D -t ~ zsh                   # Removes ~/.zshrc symlink
```

### Adding New Configurations

1. Navigate to your operating system folder
2. Create a package directory for the tool (e.g., `mkdir zsh`)
3. Add configuration files in the structure they should appear in home directory
4. Test with `stow -n -t ~ <package>` (dry run)
5. Deploy with `stow -t ~ <package>`
6. Document what each package does in a README.md inside the package
7. Commit changes with descriptive messages

See [claude.md](./claude.md) for the detailed workflow.

## Configuration Tracking

When adding new configurations, document:
- Operating system and version
- Tool/application name and version
- Purpose of the configuration
- Installation/setup instructions
- Dependencies (if any)
