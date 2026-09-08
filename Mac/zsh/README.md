# Zsh Configuration

**Tool:** Zsh - Z shell profile and environment

## Files

- `.zshrc` - Zsh shell configuration and initialization
- `.zshenv` - Environment variables loaded before .zshrc
- `.zshenv.local.template` - Template for machine-local secrets; not stowed, copy it manually

## Features

- Autocompletion with enhanced completion system
- Custom PATH configuration
- Integration with terminal workspace manager
- Modern prompt theme
- Enhanced shell completions

## Installation

1. Deploy configuration:
   ```bash
   cd ~/Projects/mySettings/Mac
   stow -t ~ zsh
   ```

2. Set up machine-local secrets:
   ```bash
   cp zsh/.zshenv.local.template ~/.zshenv.local
   # edit ~/.zshenv.local and fill in real values
   ```

3. Restart your terminal or source the config:
   ```bash
   source ~/.zshrc
   ```

## Dependencies

The following tools are used in this zsh configuration and must be installed:

- **[Zellij](https://zellij.dev/)** - Terminal workspace manager
- **[Starship](https://starship.rs/)** - Cross-shell prompt
- **[Carapace](https://carapace.sh/)** - Multi-shell completion generator
- **[Rust/Cargo](https://www.rust-lang.org/)** - Rust toolchain (cargo environment loaded in `.zshenv`)

## Configuration Highlights

- **Autocompletion:** Enabled with `compinit`
- **PATH:** Includes `~/bin`, `~/.local/bin`, and system paths
- **Auto-start:** Zellij workspace manager launches automatically
- **Prompt:** Starship theme for modern, informative prompt
- **Completions:** Carapace with zsh and bash bridges

## Environment Variables

- `MONEYBAE_DATABASE_URL` - Database connection string (project-specific)
- `CARAPACE_BRIDGES` - Enables zsh and bash completion bridges
- `TF_VAR_money_bae_db_admin_password` - Secret; lives only in untracked `~/.zshenv.local` (see `.zshenv.local.template`)
- Rust environment loaded via `~/.cargo/env`

## Notes

- Zsh is pre-installed on macOS
- History (`.zsh_history`) and sessions (`.zsh_sessions/`) are not version controlled
- This setup replaces Oh My Zsh with a minimal configuration
