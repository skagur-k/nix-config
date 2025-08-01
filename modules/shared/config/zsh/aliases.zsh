# Zsh aliases file
# This file is managed by Nix/Home-manager

alias zj='zellij'

# Use difftastic, syntax-aware diffing
alias diff=difft
alias du=dust

# Use bat instead of cat
alias cat='bat'

# Use eza instead of ls
alias ls='eza'
alias ll='eza -la'
alias la='eza -A'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gstc='git stash clear'
alias gbr='git branch'
alias gbrd='git branch -d'
alias gbrD='git branch -D'
alias gremote='git remote -v'
alias gfetch='git fetch --all'
alias gmerge='git merge'
alias grebase='git rebase'
alias greset='git reset'
alias greset--hard='git reset --hard'
alias greset--soft='git reset --soft'
alias gclean='git clean -fd'
alias gdiff='git diff'
alias gdiff--cached='git diff --cached'
alias gshow='git show'
alias gblame='git blame'
alias gtag='git tag'
alias gtag--delete='git tag -d'
alias gpush--tags='git push --tags'
alias gfetch--tags='git fetch --tags'

# Directory navigation (zoxide enhanced)
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Zoxide aliases (zoxide provides 'z' command for smart directory jumping)
alias zi='z -i'  # Interactive selection
alias zf='z -f'  # Force jump to directory even if not in database
alias zt='z -t'  # Jump to most recently accessed directory
alias zl='z -l'  # List matches instead of jumping

# Development shortcuts
alias python='python3'
alias pip='pip3'
alias node='nodejs'
alias npm='npm'
alias yarn='yarn'
alias pnpm='pnpm'

# Network aliases
alias ping='ping -c 5'
alias ping-fast='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias header='curl -I'
alias listen='lsof -i -P -n | grep LISTEN'
alias ip='curl -s https://ipinfo.io/ip'

# File management
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'

# Text processing
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias wc='wc -l'
alias head='head -20'
alias tail='tail -20'

# Archive management
alias untar='tar -xvf'
alias targz='tar -czvf'
alias tarbz2='tar -cjvf'

# Process management
alias ps='ps auxf'
alias psgrep='ps aux | grep'
alias meminfo='free -l -h'
alias cpuinfo='lscpu'

# Kubernetes aliases (if you use K8s)
alias kc='kubectl'
alias kx='kubectx'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'
alias ka='kubectl apply'
alias kdel='kubectl delete'
alias kctx='kubectl config use-context'
alias kctxs='kubectl config get-contexts'

# Editor aliases
alias v='vim'
alias nv='nvim'
alias code='code'

# Quick file editing
alias zshrc='hx ~/.zshrc'
alias vimrc='hx ~/.vimrc'
alias bashrc='hx ~/.bashrc'
alias sshconfig='hx ~/.ssh/config'

# Utility aliases
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime='now'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'

# History aliases
alias h='history'
alias h1='history 10'
alias h2='history 20'
alias h3='history 30'
alias hgrep='history | grep'

 