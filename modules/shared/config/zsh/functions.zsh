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

# Check if nix-config repo is behind origin
check_nix_config_status() {
    local nix_config_path="$HOME/nix-config"
    
    # Debug: Check if directory exists
    if [[ ! -d "$nix_config_path" ]]; then
        echo "❌ nix-config directory not found at $nix_config_path"
        return 1
    fi
    
    # Debug: Check if it's a git repository
    if ! git -C "$nix_config_path" rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ $nix_config_path is not a git repository"
        return 1
    fi
    
    echo "🔍 Checking nix-config status..."
    
    # Check if the nix-config directory exists and is a git repository
    if [[ -d "$nix_config_path" ]] && git -C "$nix_config_path" rev-parse --git-dir > /dev/null 2>&1; then
        # Fetch from origin quietly
        git -C "$nix_config_path" fetch origin > /dev/null 2>&1
        
        # Get current branch
        local current_branch=$(git -C "$nix_config_path" branch --show-current)
        
        # Check if current branch has an upstream
        local upstream=$(git -C "$nix_config_path" rev-parse --abbrev-ref "$current_branch@{upstream}" 2>/dev/null)
        
        if [[ -z "$upstream" ]]; then
            echo "❌ No upstream branch configured for '$current_branch'"
            echo "   Run: git branch --set-upstream-to=origin/$current_branch $current_branch"
            return 1
        fi
        
        echo "📡 Comparing with upstream: $upstream"
        
        if [[ -n "$upstream" ]]; then
            # Compare local HEAD with upstream
            local local_commit=$(git -C "$nix_config_path" rev-parse HEAD)
            local remote_commit=$(git -C "$nix_config_path" rev-parse "$upstream")
            
            if [[ "$local_commit" != "$remote_commit" ]]; then
                # Check if local is behind remote
                local behind_count=$(git -C "$nix_config_path" rev-list --count HEAD.."$upstream" 2>/dev/null)
                local ahead_count=$(git -C "$nix_config_path" rev-list --count "$upstream"..HEAD 2>/dev/null)
                
                if [[ "$behind_count" -gt 0 ]]; then
                    echo ""
                    echo "🔄 Your nix-config is $behind_count commit(s) behind $upstream"
                    if [[ "$ahead_count" -gt 0 ]]; then
                        echo "   (and $ahead_count commit(s) ahead)"
                    fi
                    echo ""
                    echo -n "   Would you like to pull and switch to the latest changes? (y/N): "
                    read -r response
                    if [[ "$response" =~ ^[Yy]$ ]]; then
                        if [[ "$ahead_count" -gt 0 ]]; then
                            echo "   Running git pull --rebase..."
                            git -C "$nix_config_path" pull --rebase
                            just switch
                        else
                            echo "   Running git pull..."
                            git -C "$nix_config_path" pull
                        fi
                    fi
                    echo ""
                elif [[ "$ahead_count" -gt 0 ]]; then
                    echo ""
                    echo "⬆️  Your nix-config is $ahead_count commit(s) ahead of $upstream"
                    echo ""
                fi
            else
                # Local and remote are in sync
                echo ""
                echo "✅ Your nix-config is up to date with $upstream"
            fi
        fi
    else
        echo "❌ Failed to access nix-config repository"
    fi
}

