# Zsh functions file
# This file is managed by Nix/Home-manager

# Nix shortcuts
shell() {
    nix-shell '<nixpkgs>' -A "$1"
}

# Extract function for various archive types
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick directory creation and navigation
cdl() {
    cd "$1" && eza -la
}

# Eza helper functions
eza-tree() {
    eza --tree --level=${1:-2} "${@:2}"
}

eza-icons() {
    eza --icons "${@:1}"
}

eza-git() {
    eza --git "${@:1}"
}

eza-details() {
    eza -la --icons --git "${@:1}"
}

# Zoxide helper functions
zoxide-add() {
    # Add current directory to zoxide database
    zoxide add "$(pwd)"
    echo "Added $(pwd) to zoxide database"
}

zoxide-query() {
    # Query zoxide database for a specific path
    zoxide query "$1"
}

