# Rust/Cargo environment
. "$HOME/.cargo/env"

# Path configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Add .NET Core SDK tools
export PATH="$PATH:$HOME/.dotnet/tools"

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
