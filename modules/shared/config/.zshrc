# Load Nix environment
if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

# Define variables for directories
export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
export PATH=$HOME/.local/share/bin:$PATH

# Remove history data we don't want to see
export HISTIGNORE="pwd:ls:cd"

# Source zsh configuration files
if [[ -f ~/.config/zsh/aliases.zsh ]]; then
    source ~/.config/zsh/aliases.zsh
fi

if [[ -f ~/.config/zsh/functions.zsh ]]; then
    source ~/.config/zsh/functions.zsh
fi

# if [[ -f ~/.config/zsh/keybindings.zsh ]]; then
#     source ~/.config/zsh/keybindings.zsh
# fi

# Bind common terminal escape sequences
bindkey '\e[H' beginning-of-line         # Home
bindkey '\e[F' end-of-line               # End
bindkey '\e[5~' history-search-backward  # Page Up
bindkey '\e[6~' history-search-forward   # Page Down
bindkey '\e[3~' delete-char              # Delete

# Better history searching
bindkey '^R' history-incremental-search-backward
bindkey '^@' autosuggest-accept

# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Set editor
export EDITOR=helix
export VISUAL=helix

eval "$(zellij setup --generate-auto-start zsh)"