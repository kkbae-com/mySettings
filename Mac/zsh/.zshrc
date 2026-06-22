# AutoComplete
autoload -Uz compinit
compinit

# Completion styling
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Terminal Workspace: https://zellij.dev/documentation/integration.html
eval "$(zellij setup --generate-auto-start zsh)"

# Prompt: using Starship https://starship.rs/
eval "$(starship init zsh)"

# Completions: https://carapace.sh/
source <(carapace _carapace)

# Enable vi mode
bindkey -v

# direnv
eval "$(direnv hook zsh)"
