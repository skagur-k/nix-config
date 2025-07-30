export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --border"

export SKIM_DEFAULT_COMMAND="eza --all --color=always"
export SKIM_DEFAULT_OPTIONS="--height 40% --border"

# Set editor
export EDITOR=helix
export VISUAL=helix

# Define variables for directories
export PATH=$HOME/.pnpm-packages/bin:$HOME/.pnpm-packages:$PATH
export PATH=$HOME/.npm-packages/bin:$HOME/bin:$PATH
export PATH=$HOME/.local/share/bin:$PATH

# Remove history data we don't want to see
export HISTIGNORE="pwd:ls:cd"