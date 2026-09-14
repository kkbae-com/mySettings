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
brew install --cask ghostty omniwm     # Terminal emulator and window manager
brew install zellij starship carapace  # Terminal workspace, prompt, and completions
brew install direnv                    # Per-directory environment variables
brew install libpq                     # PostgreSQL client tools (psql, pg_dump, ...)
brew install --cask docker             # Container runtime for databases/servers
```

### Databases and other servers: Docker, not Homebrew services

Servers - PostgreSQL included - run in **Docker containers**, not as Homebrew
services. Homebrew installs only *client* tooling.

That's why the list above has `brew install libpq` and not
`brew install postgresql@NN`: the latter pulls in a server daemon this setup
doesn't use. `psql`, `pg_dump`, `pg_restore` and `pg_isready` all come from
`libpq` and connect to whatever is running in Docker. `libpq` is keg-only, so
Homebrew doesn't link its binaries onto `PATH` - `.zshenv` adds its `bin`
directory explicitly.

Connection strings are machine-local - they depend on the container's role name
and published port - so they belong in untracked `~/.zshenv.local`, not in the
tracked `.zshenv`. See `.zshenv.local.template` for the `MONEYBAE_DATABASE_URL`
starting point.

**Licensing note:** Docker Desktop requires a paid subscription for larger
organizations. [OrbStack](https://orbstack.dev/) (`brew install --cask orbstack`)
and [Colima](https://github.com/abiosoft/colima) (`brew install colima docker`)
are drop-in alternatives that avoid that if it applies here.

**Window manager:** OmniWM replaced AeroSpace as the window manager for this repo.
The `aerospace-1monitor`/`aerospace-2monitor` packages are still tracked as a
fallback - install `brew install --cask aerospace` instead of `omniwm` if you're
going that route. OmniWM requires macOS 26 (Tahoe) or later on Apple Silicon;
AeroSpace remains the option on Intel or older macOS.

### 2. Clone This Repository

```bash
mkdir -p ~/Documents/Projects/kkbae
cd ~/Documents/Projects/kkbae
git clone git@github.com:kkbae-com/mySettings.git
cd mySettings
```

### 3. Deploy Configurations

See the [Deploying Configurations](#deploying-configurations) section below for stow usage.

### Package-Specific Dependencies

Each configuration package has its own README with detailed installation instructions:

- **ghostty** - Requires Ghostty terminal emulator (`brew install --cask ghostty`)
- **zsh** - Requires Starship, Carapace, direnv, and Rust/Cargo. `libpq`
  (`brew install libpq`) is optional but recommended - it provides `psql`/`pg_dump`/
  `pg_restore`; it's keg-only, so `.zshenv` adds its `bin` to `PATH` explicitly and
  no-ops if it isn't installed. Zellij is also optional - the shell no longer
  auto-starts it
- **zellij** - Requires Zellij terminal workspace manager (`brew install zellij`).
  Optional; started on demand rather than per shell
- **omniwm** - Requires OmniWM window manager (`brew install --cask omniwm`), macOS 26+
  on Apple Silicon. Has extra first-run setup (separate Spaces per display, Accessibility
  and Input Monitoring permissions, removing the default generated config before stowing)
  and an optional Sidecar LaunchAgent - see [Mac/omniwm/README.md](./Mac/omniwm/README.md)
  before deploying
- **aerospace-1monitor** / **aerospace-2monitor** - Fallback window manager, requires
  AeroSpace (`brew install --cask aerospace`). Mutually exclusive with each other and
  with **omniwm**
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

## Machine-Specific vs. Shared Configuration

This repo is shared across multiple machines. Tracked config files must stay
identical for everyone who stows this repo - so anything that only applies to
one machine (an install path, a local secret, a one-off tweak) must never be
committed directly into a tracked file.

The convention: a tracked file sources an untracked, machine-local
counterpart if one exists, e.g. in `.zshenv`:

```bash
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"
```

- The real `~/.foo.local` file lives only in `$HOME` - it is never tracked
  and never stowed/symlinked, so a `git pull` on another machine can't
  overwrite it and it can't leak machine-specific values into the shared repo.
- A `<file>.local.template` (e.g. `.zshenv.local.template`,
  `.zshrc.local.template`) is what actually gets tracked and stowed - it
  documents the hook and gives new machines a starting point:
  ```bash
  cp Mac/zsh/.zshenv.local.template ~/.zshenv.local
  ```
- Before adding something to a tracked file, ask whether every machine
  running this repo should get it. If not, it belongs in the local file, not
  the template.

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

1. Clone this repository (recommended location: `~/Documents/Projects/kkbae/mySettings`)
2. Navigate to your OS-specific folder:
   ```bash
   cd ~/Documents/Projects/kkbae/mySettings/Mac  # or Windows, or Linux
   ```
3. Deploy a specific package with explicit target:
   ```bash
   stow -t ~ zsh         # Creates ~/.zshrc symlink
   stow -t ~ git         # Creates ~/.gitconfig symlink
   ```
4. Deploy every package *except* the window managers (see the next section - the
   window manager packages are mutually exclusive, so `*/` is not safe here):
   ```bash
   stow -t ~ ghostty git zellij zsh
   ```

**Note:** The `-t ~` flag explicitly targets your home directory. Without it, stow creates symlinks in the parent directory of where you run it.

### Managing Multiple Configurations for the Same Tool

Some tools have multiple configuration packages for different setups. The window
manager is the live example - three mutually exclusive packages:

| Package | Use |
| --- | --- |
| `omniwm` | Current default. macOS 26+ on Apple Silicon |
| `aerospace-1monitor` | Fallback, single monitor |
| `aerospace-2monitor` | Fallback, dual monitor |

1. **Only deploy ONE variant at a time**
2. **Remove the current variant before deploying another**
3. **Quit the running window manager before switching** - two tiling WMs running at
   once will fight over window control

```bash
# Deploy the current default
stow -t ~ omniwm

# To switch to the AeroSpace fallback:
# First quit OmniWM (menu bar icon, or via omniwmctl), then unstow it
stow -D -t ~ omniwm

# Then deploy one AeroSpace variant
stow -t ~ aerospace-1monitor    # or aerospace-2monitor
aerospace reload-config
```

`omniwm` and the `aerospace-*` packages don't write to the same paths, so stow
itself won't complain about deploying both - but the two apps will conflict at
runtime. The two `aerospace-*` variants *do* both provide `.aerospace.toml` and
will collide in stow.

OmniWM has first-run setup beyond stowing (separate Spaces per display,
Accessibility/Input Monitoring permissions, clearing the default generated config)
and `start-at-login` needs flipping on the AeroSpace side when you migrate - see
[Mac/omniwm/README.md](./Mac/omniwm/README.md) for the full sequence in both
directions.

**Important:** Never run `stow -t ~ */` in `Mac/` - it will try to deploy all three
window manager packages at once. Deploy packages selectively instead.

### Removing Configurations

```bash
cd ~/Documents/Projects/kkbae/mySettings/Mac
stow -D -t ~ omniwm                # Removes omniwm symlinks
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
