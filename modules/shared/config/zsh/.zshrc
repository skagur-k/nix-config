# Load Nix environment
if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

# Source zsh configuration files
if [[ -f ~/.config/zsh/env.zsh ]]; then
    source ~/.config/zsh/env.zsh
fi

if [[ -f ~/.config/zsh/aliases.zsh ]]; then
    source ~/.config/zsh/aliases.zsh
fi

if [[ -f ~/.config/zsh/functions.zsh ]]; then
    source ~/.config/zsh/functions.zsh
fi

if [[ -f ~/.config/zsh/keybindings.zsh ]]; then
    source ~/.config/zsh/keybindings.zsh
fi


# History configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# eval "$(zellij setup --generate-auto-start zsh)"