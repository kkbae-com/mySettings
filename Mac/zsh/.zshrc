# AutoComplete
autoload -Uz compinit
compinit

# Completion styling
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Terminal Workspace: https://zellij.dev/documentation/integration.html
#
# Auto-start is OPT-IN. Most shells don't need a Zellij session, so instead of
# starting one on every new shell, run `zellij` (or `zellij attach -c main` to
# reuse a persistent session) when you actually want one.
#
# To turn auto-start back on, uncomment the line below - either here, if every
# machine sharing this repo should get it, or by copying the line into
# ~/.zshrc.local to enable it on just this machine (see .zshrc.local.template).
# ZELLIJ_AUTO_ATTACH=true reuses a session instead of creating a new one each
# time; ZELLIJ_AUTO_EXIT=true closes the shell when you leave Zellij.
#
# eval "$(zellij setup --generate-auto-start zsh)"

# Prompt: using Starship https://starship.rs/
eval "$(starship init zsh)"

# Completions: https://carapace.sh/
source <(carapace _carapace)

# Enable vi mode
bindkey -v

# direnv
eval "$(direnv hook zsh)"

# Node via nvm - installed with nvm's own install script into ~/.nvm, NOT
# Homebrew. nvm is a shell function rather than a binary, so it has to be
# sourced here in .zshrc; it can't be a plain PATH export in .zshenv.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Machine-local additions - not tracked, see .zshrc.local.template
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
