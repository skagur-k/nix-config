export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --border"

export SKIM_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export SKIM_DEFAULT_OPTIONS='--ansi --height 40% --border --preview "if [ -d {} ]; then eza -lah --color=always {}; else bat --style=numbers --color=always --line-range :500 {}; fi"'

# Set editor
export EDITOR=hx
export VISUAL=hx

# Define variables for directories
export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
export PATH=$HOME/.local/share/bin:$PATH

# Remove history data we don't want to see
export HISTIGNORE="pwd:ls:cd"

export XDG_CONFIG_HOME=$HOME/.config

# Encryption
export SOPS_AGE_KEY_FILE="$XDG_CONFIG_HOME/sops/age/keys.txt"
export SOPS_AGE_RECIPIENTS="age1rjwgaj5s78duptsp24y9g80fh0wvqddcjucrhzsrg7eysw0sxeusm29l45"