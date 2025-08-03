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

# Display all aliases with descriptions and color-coding
show_aliases() {
    local aliases_file="$HOME/.config/zsh/aliases.zsh"
    
    # Check if aliases file exists
    if [[ ! -f "$aliases_file" ]]; then
        echo "❌ Aliases file not found at $aliases_file"
        return 1
    fi
    
    echo ""
    print -P "%F{cyan}%B🎨 === Shell Aliases Reference ===%b%f"
    echo ""
    
    # Enable colors using zsh color codes
    autoload -U colors && colors
    
    # Color codes using zsh built-in colors
    local category_color="%F{magenta}%B"     # Bold magenta for categories
    local alias_color="%F{green}%B"          # Bold green for alias names  
    local command_color="%F{yellow}%B"       # Bold yellow for commands
    local desc_color="%F{blue}"              # Blue for descriptions
    local reset="%b%f"                       # Reset colors
    local separator_color="%F{cyan}"         # Cyan for separators
    
    local current_category=""
    local in_category=false
    
    while IFS= read -r line; do
        # Skip empty lines and file header
        if [[ -z "$line" || "$line" =~ '^#.*file.*managed.*Nix' ]]; then
            continue
        fi
        
        # Check for category headers (comments that aren't inline)
        if [[ "$line" =~ '^#[[:space:]]*([^[:space:]].*)$' ]]; then
            local comment_text="${match[1]}"
            # Skip inline comments (lines that have aliases with comments)
            if [[ ! "$comment_text" =~ '(Interactive|Force|Jump|provides)' ]]; then
                # Add spacing before new category (except for the first one)
                if [[ -n "$current_category" ]]; then
                    echo ""
                fi
                current_category="$comment_text"
                in_category=true
                print -P "${category_color}📂 $current_category${reset}"
                print -P "${separator_color}   ────────────────────────────────────${reset}"
                continue
            fi
        fi
        
        # Parse alias lines
        if [[ "$line" =~ '^alias[[:space:]]+([^=]+)=(.*)$' ]]; then
            local alias_name="${match[1]}"
            local full_command="${match[2]}"
            
            # Split command and comment - handle quotes properly
            local alias_command="$full_command"
            local comment=""
            
            # Check if there's a comment outside of quotes
            if [[ "$full_command" =~ '^(['\''"][^'\''"]*)(['\''"])(.*)$' ]]; then
                # Quoted command, check what's after the closing quote
                local quoted_part="${match[1]}${match[2]}"
                local after_quote="${match[3]}"
                if [[ "$after_quote" =~ '^[[:space:]]*(#.*)$' ]]; then
                    alias_command="$quoted_part"
                    comment="${match[1]}"
                else
                    alias_command="$full_command"
                fi
            elif [[ "$full_command" =~ '^([^#]*)(#.*)$' ]]; then
                # Unquoted command with comment
                alias_command="${match[1]}"
                comment="${match[2]}"
            fi
            
            # Clean up the command - remove trailing whitespace and quotes
            alias_command="${alias_command%% }"
            alias_command="${alias_command#\'}"
            alias_command="${alias_command%\'}"
            alias_command="${alias_command#\"}"
            alias_command="${alias_command%\"}"
            
            # Extract inline comment if present
            local description=""
            if [[ -n "$comment" && "$comment" =~ '#[[:space:]]*(.+)$' ]]; then
                description=" ${desc_color}# ${match[1]}${reset}"
            fi
            
            # Add contextual descriptions for common aliases
            if [[ -z "$description" ]]; then
                case "$alias_name" in
                    "js") description=" ${desc_color}# Just switch - rebuild nix config${reset}" ;;
                    "ncc") description=" ${desc_color}# Check nix-config status${reset}" ;;
                    "diff") description=" ${desc_color}# Use delta for better diffs${reset}" ;;
                    "du") description=" ${desc_color}# Use dust for disk usage${reset}" ;;
                    "ff") description=" ${desc_color}# Show system info${reset}" ;;
                    "zj") description=" ${desc_color}# Terminal multiplexer${reset}" ;;
                    "lg") description=" ${desc_color}# Git TUI${reset}" ;;
                    "cat") description=" ${desc_color}# Use bat for syntax highlighting${reset}" ;;
                    "ls") description=" ${desc_color}# Modern ls with colors${reset}" ;;
                    "ll") description=" ${desc_color}# Long listing with details${reset}" ;;
                    "la") description=" ${desc_color}# List all files${reset}" ;;
                    "gs") description=" ${desc_color}# Git status${reset}" ;;
                    "ga") description=" ${desc_color}# Git add${reset}" ;;
                    "gc") description=" ${desc_color}# Git commit${reset}" ;;
                    "gp") description=" ${desc_color}# Git push${reset}" ;;
                    "gl") description=" ${desc_color}# Git log one line${reset}" ;;
                    "gco") description=" ${desc_color}# Git checkout${reset}" ;;
                    "gcb") description=" ${desc_color}# Git checkout new branch${reset}" ;;
                    "gpl") description=" ${desc_color}# Git pull${reset}" ;;
                    "..") description=" ${desc_color}# Go up one directory${reset}" ;;
                    "...") description=" ${desc_color}# Go up two directories${reset}" ;;
                    "....") description=" ${desc_color}# Go up three directories${reset}" ;;
                    ".....") description=" ${desc_color}# Go up four directories${reset}" ;;
                    "python") description=" ${desc_color}# Use python3${reset}" ;;
                    "pip") description=" ${desc_color}# Use pip3${reset}" ;;
                    "ping") description=" ${desc_color}# Ping with 5 packets${reset}" ;;
                    "ports") description=" ${desc_color}# Show listening ports${reset}" ;;
                    "ip") description=" ${desc_color}# Get external IP address${reset}" ;;
                    "cp") description=" ${desc_color}# Copy with confirmation${reset}" ;;
                    "mv") description=" ${desc_color}# Move with confirmation${reset}" ;;
                    "rm") description=" ${desc_color}# Remove with confirmation${reset}" ;;
                    "mkdir") description=" ${desc_color}# Create directory path${reset}" ;;
                    "df") description=" ${desc_color}# Disk usage human readable${reset}" ;;
                    "free") description=" ${desc_color}# Memory usage human readable${reset}" ;;
                    "top") description=" ${desc_color}# Use htop instead${reset}" ;;
                    "grep") description=" ${desc_color}# Grep with colors${reset}" ;;
                    "kc") description=" ${desc_color}# Kubectl shorthand${reset}" ;;
                    "v") description=" ${desc_color}# Vim editor${reset}" ;;
                    "nv") description=" ${desc_color}# Neovim editor${reset}" ;;
                    "zshrc") description=" ${desc_color}# Edit zsh config${reset}" ;;
                    "path") description=" ${desc_color}# Show PATH variable${reset}" ;;
                    "now") description=" ${desc_color}# Current time${reset}" ;;
                    "h") description=" ${desc_color}# Command history${reset}" ;;
                esac
            fi
            
            # Format and display the alias
            print -P "   ${alias_color}$(printf '%-12s' "$alias_name")${reset} ${separator_color}→${reset} ${command_color}$(printf '%-30s' "$alias_command")${reset}$description"
        fi
    done < "$aliases_file"
    
    echo ""
    print -P "${separator_color}═══════════════════════════════════════════════════════════════${reset}"
    print -P "${desc_color}💡 Tip: Use 'which <alias>' to see what an alias points to${reset}"
    print -P "${desc_color}📝 Edit aliases: hx ~/.config/zsh/aliases.zsh${reset}"
    echo ""
}

# Alias for the show_aliases function
alias aliases='show_aliases'
alias sa='show_aliases'

