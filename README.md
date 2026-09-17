# mySettings

A centralized repository for storing operating system configurations and environment setups across different platforms, managed with GNU Stow.

## Required Tools & Languages

**GNU Stow** is the only hard prerequisite - it's what deploys everything else.

- macOS: `brew install stow`
- Linux: `sudo apt install stow` or `sudo yum install stow`
- Windows: Use WSL or install via Chocolatey: `choco install stow`

Everything else below is what the tracked configs expect. The split matters:
**CLI tools and apps come from Homebrew; language toolchains never do.**

### Via Homebrew

| Tool | Formula / Cask | Required? | Used for |
| --- | --- | --- | --- |
| GNU Stow | `stow` | **Yes** | Symlinking packages into `$HOME` |
| Ghostty | `--cask ghostty` | Yes | Terminal emulator |
| Starship | `starship` | Yes | Shell prompt (`.zshrc`) |
| Carapace | `carapace` | Yes | Shell completions (`.zshrc`) |
| direnv | `direnv` | Yes | Per-directory env vars (`.zshrc`) |
| OmniWM | `--cask omniwm` | Optional | Window manager, macOS 26+ Apple Silicon |
| AeroSpace | `--cask aerospace` | Optional | Fallback window manager |
| Zellij | `zellij` | Optional | Terminal workspaces; started on demand, not per shell |
| libpq | `libpq` | Optional | `psql`/`pg_dump`/`pg_restore` - **client only**, no server |
| Docker Desktop | `--cask docker-desktop` | Optional | Runs Postgres and any other servers |
| GitHub CLI | `gh` | Optional | `gh` auth, SSH key upload, PRs |
| AWS CLI | `awscli` | Optional | `aws sso login`, per-project profiles (see [AWS Configuration Per Project](#aws-configuration-per-project)) |

### Not via Homebrew - language toolchains

| Language | Installer | Lands in | Shell wiring |
| --- | --- | --- | --- |
| Rust | [rustup.rs](https://rustup.rs) | `~/.cargo`, `~/.rustup` | `.zshenv` sources `~/.cargo/env` |
| .NET | `dotnet-install.sh` | `~/.dotnet` | `.zshenv` sets `DOTNET_ROOT` |
| Go | [go.dev](https://go.dev/dl/) tarball | `~/.local/go` | `.zshenv` sets `GOROOT`/`GOPATH` |
| Node | [nvm](https://github.com/nvm-sh/nvm) | `~/.nvm` | `.zshrc` sources `nvm.sh` |

See [Install Language Toolchains](#2-install-language-toolchains---not-via-homebrew)
for the commands and the reasoning.

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
brew install --cask docker-desktop     # Container runtime for databases/servers
```

### 2. Install Language Toolchains - NOT via Homebrew

Rust, .NET, Go and Node are each installed with their **own official installer**,
not Homebrew. Every one lands under `$HOME`, so none of them needs `sudo`, and
each keeps its own version manager for switching releases per project - which is
the point: Homebrew upgrades a toolchain out from under you on an unrelated
`brew upgrade`, and pins you to whatever single version it packages.

`.zshenv` and `.zshrc` expect these exact locations. Each block is guarded by a
directory check, so a machine missing one of these toolchains is fine - the
shell just skips it.

```bash
# Rust -> ~/.cargo, ~/.rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# .NET SDK (LTS) -> ~/.dotnet
curl -fsSL https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel LTS --install-dir "$HOME/.dotnet"

# Go -> ~/.local/go   (GOPATH stays at ~/go)
GOVER=$(curl -fsSL 'https://go.dev/VERSION?m=text' | head -1)
curl -fsSL -o "$GOVER.darwin-arm64.tar.gz" "https://go.dev/dl/$GOVER.darwin-arm64.tar.gz"
tar -C "$HOME/.local" -xzf "$GOVER.darwin-arm64.tar.gz"

# Node via nvm -> ~/.nvm
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
nvm install --lts && nvm alias default 'lts/*'
```

| Toolchain | Installed to | Shell wiring | Why not Homebrew |
| --- | --- | --- | --- |
| Rust | `~/.cargo`, `~/.rustup` | `.zshenv` sources `~/.cargo/env` | Homebrew's `rustup` is keg-only, stores state in `~/.rustup`, and **never writes `~/.cargo/env`** - so `.zshenv` fails at startup and `cargo` is missing from `PATH` |
| .NET | `~/.dotnet` | `.zshenv` sets `DOTNET_ROOT` + `PATH` | Keeps SDK/runtime versions under `dotnet-install.sh` control, side-by-side per channel |
| Go | `~/.local/go` | `.zshenv` sets `GOROOT`, `GOPATH` | Official tarball; avoids `sudo` writes to `/usr/local/go` |
| Node | `~/.nvm` | `.zshrc` sources `nvm.sh` | `nvm` switches versions per project; a Homebrew `node` would shadow it on `PATH` |

Two gotchas worth knowing:

- **nvm is a shell function, not a binary**, so it's initialised in `.zshrc`, not
  `.zshenv`. It can't be a plain `PATH` export.
- **If Homebrew's rustup is already installed**, back it out first or it will
  conflict with the keg-only shims:
  ```bash
  brew uninstall rustup && rm -rf ~/.rustup /opt/homebrew/etc/rustup
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

**Managed Macs:** cask installs copy an app into `/Applications` via `sudo`. On a
machine with a managed sudo policy that demands a typed justification, Homebrew
can't answer that prompt and the install fails with `sudo: no password was
provided`. Run the cask installs yourself in an interactive terminal; the
downloads are already cached, so the retry is quick.

**Window manager:** OmniWM replaced AeroSpace as the window manager for this repo.
The `aerospace-1monitor`/`aerospace-2monitor` packages are still tracked as a
fallback - install `brew install --cask aerospace` instead of `omniwm` if you're
going that route. OmniWM requires macOS 26 (Tahoe) or later on Apple Silicon;
AeroSpace remains the option on Intel or older macOS.

### 3. Clone This Repository

```bash
mkdir -p ~/Documents/Projects/kkbae
cd ~/Documents/Projects/kkbae
git clone git@github.com:kkbae-com/mySettings.git
cd mySettings
```

### 4. Deploy Configurations

See the [Deploying Configurations](#deploying-configurations) section below for stow usage.

### Package-Specific Dependencies

Each configuration package has its own README with detailed installation instructions:

- **ghostty** - Requires Ghostty terminal emulator (`brew install --cask ghostty`)
- **zsh** - Requires Starship, Carapace and direnv. Every language toolchain it
  wires up (Rust, .NET, Go, Node) is guarded by a directory check, so each is
  optional and a missing one is silently skipped. `libpq` is optional but
  recommended - keg-only, so `.zshenv` adds its `bin` to `PATH` explicitly.
  Zellij is optional too; the shell no longer auto-starts it
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

## AWS Configuration Per Project

Client work (e.g. a project folder like `sharkninja`) authenticates via
**AWS SSO** - no static IAM access keys, no `~/.aws/credentials`. The active
profile switches automatically per directory using `direnv`, the same tool
already used for other per-project env vars.

- **`~/.aws/config`** holds one `[profile <name>]` block per client, e.g.:
  ```ini
  [profile sharkninja]
  sso_start_url  = https://<your-sso-portal>.awsapps.com/start
  sso_region     = us-east-1
  sso_account_id = 111111111111
  sso_role_name  = <RoleName>
  region         = us-east-1
  output         = json
  ```
  These values (account ID, role name, SSO URL) aren't secrets, just
  identifiers - unlike an access key, so unlike `~/.aws/credentials`, this
  file is safe to keep tracked/shared if it's added as a package here later.
- **Each project's own repo** (not this one) gets a `.envrc` setting
  `export AWS_PROFILE=sharkninja`, then `direnv allow` once. `cd`-ing into
  the project auto-selects its profile; leaving it restores the previous
  `AWS_PROFILE` (or none).
- **Logging in** is `aws sso login --profile sharkninja` - opens a browser,
  then caches a short-lived session token under `~/.aws/sso/cache` and
  `~/.aws/cli/cache`. Those caches are machine/session-specific and are
  never tracked or stowed.
- **No static keys**: `~/.aws/credentials` doesn't exist in this setup and
  shouldn't be created. If a project ever needs long-lived IAM keys instead
  of SSO, they go in that untracked file only - never in `~/.aws/config` and
  never committed.

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
   stow --no-folding -t ~ zsh         # Creates ~/.zshrc symlink
   stow --no-folding -t ~ git         # Creates ~/.gitconfig symlink
   ```
4. Deploy every package *except* the window managers (see the next section - the
   window manager packages are mutually exclusive, so `*/` is not safe here):
   ```bash
   stow --no-folding -t ~ ghostty git zellij zsh
   ```

**Note:** The `-t ~` flag explicitly targets your home directory. Without it, stow creates symlinks in the parent directory of where you run it.

### Always use `--no-folding`

```bash
stow --no-folding -t ~ <package>
```

By default stow "folds": when a target directory doesn't exist yet, it symlinks
the whole directory instead of the files inside it. That points a live
application directory straight at this git repo, so anything the app writes
there lands in your working tree:

| Without `--no-folding` | Consequence |
| --- | --- |
| `~/.config/omniwm` -> repo | OmniWM regenerates `settings.toml` **into the repo** |
| `~/.config/zellij` -> repo | Zellij writes layouts/themes into the repo |
| `~/Library/LaunchAgents` -> repo | *Any* app installing a login item writes into the repo |

`--no-folding` creates real directories and symlinks only the tracked files, so
those writes stay in `$HOME` where they belong. To fix an already-folded
package, unstow and restow it:

```bash
stow -D -t ~ <package>
stow --no-folding -t ~ <package>
```

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
stow --no-folding -t ~ omniwm

# To switch to the AeroSpace fallback:
# First quit OmniWM (menu bar icon, or via omniwmctl), then unstow it
stow -D -t ~ omniwm

# Then deploy one AeroSpace variant
stow --no-folding -t ~ aerospace-1monitor    # or aerospace-2monitor
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
4. Test with `stow -n -v --no-folding -t ~ <package>` (dry run, shows each link)
5. Deploy with `stow --no-folding -t ~ <package>`
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
