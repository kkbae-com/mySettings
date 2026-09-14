# Rust/Cargo environment
. "$HOME/.cargo/env"

# Path configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# .NET SDK - installed with Microsoft's dotnet-install.sh into ~/.dotnet, NOT
# Homebrew. DOTNET_ROOT is required when the SDK lives outside the system
# location, otherwise `dotnet` can't find its shared runtimes. ~/.dotnet holds
# the `dotnet` binary itself; ~/.dotnet/tools holds `dotnet tool install -g`
# binaries, which go last so they can't shadow the SDK.
if [ -d "$HOME/.dotnet" ]; then
  export DOTNET_ROOT="$HOME/.dotnet"
  export PATH="$DOTNET_ROOT:$PATH:$DOTNET_ROOT/tools"
fi

# Go - installed from the official go.dev tarball into ~/.local/go, NOT Homebrew.
# GOROOT is set because the tarball isn't at Go's default /usr/local/go.
if [ -d "$HOME/.local/go" ]; then
  export GOROOT="$HOME/.local/go"
  export PATH="$GOROOT/bin:$PATH"
fi

# Go workspace: module cache and `go install` binaries
export GOPATH="$HOME/go"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"

# Carapace completion bridges
export CARAPACE_BRIDGES='zsh,bash'

# PostgreSQL CLIENT tools only - psql, pg_dump, pg_restore, pg_isready - from the
# keg-only libpq formula (`brew install libpq`). Servers, Postgres included, run in
# Docker rather than as Homebrew services, so the full `postgresql@NN` formula is
# deliberately not installed.
#
# Both prefixes are checked so this works on Apple Silicon (/opt/homebrew) and
# Intel (/usr/local), and no-ops when libpq isn't installed.
for _libpq_bin in /opt/homebrew/opt/libpq/bin /usr/local/opt/libpq/bin; do
  [ -d "$_libpq_bin" ] && export PATH="$_libpq_bin:$PATH"
done
unset _libpq_bin

# Machine-local secrets - not tracked, see .zshenv.local.template
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"
