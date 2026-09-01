# Rust/Cargo environment
. "$HOME/.cargo/env"

# Path configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Add .NET Core SDK tools
export PATH="$PATH:/Users/kmerecido/.dotnet/tools"

# postgresql (keg-only via Homebrew - psql/pg_restore/etc not linked by default)
export PATH="$(brew --prefix postgresql)/bin:$PATH"

# Project-specific environment variables
export MONEYBAE_DATABASE_URL="postgres://mrcunninghamz@localhost/money_bae"

# Carapace completion bridges
export CARAPACE_BRIDGES='zsh,bash'
