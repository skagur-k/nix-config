# Bind common terminal escape sequences
bindkey '\e[H' beginning-of-line         # Home
bindkey '\e[F' end-of-line               # End
bindkey '\e[5~' history-search-backward  # Page Up
bindkey '\e[6~' history-search-forward   # Page Down
bindkey '\e[3~' delete-char              # Delete

# Better history searching
bindkey '^ ' autosuggest-accept

bindkey ';2;13~' accept-line