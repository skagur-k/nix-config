# Bind common terminal escape sequences
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End
bindkey '^[[5~' history-search-backward  # Page Up
bindkey '^[[6~' history-search-forward   # Page Down
bindkey '^[[3~' delete-char         # Delete

# Better history searching
bindkey '^R' history-incremental-search-backward
bindkey '^ ' autosuggest-accept