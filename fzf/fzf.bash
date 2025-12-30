# fzf configuration for bash
# Source this file from ~/.bashrc

# ===========================================
# fzf installation check
# ===========================================
# fzf is typically installed via:
#   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#   ~/.fzf/install

# ===========================================
# Basic settings
# ===========================================
# Default command - use fd if available, otherwise find
if command -v fdfind &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
elif command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
fi

# Default options
export FZF_DEFAULT_OPTS='
    --height=40%
    --layout=reverse
    --border=rounded
    --info=inline
    --margin=1
    --padding=1
    --prompt="  "
    --pointer=""
    --marker=""
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
    --bind=ctrl-d:half-page-down
    --bind=ctrl-u:half-page-up
    --bind=ctrl-y:preview-up
    --bind=ctrl-e:preview-down
'

# ===========================================
# CTRL-T: File search
# ===========================================
if command -v fdfind &> /dev/null; then
    export FZF_CTRL_T_COMMAND='fdfind --type f --hidden --follow --exclude .git'
elif command -v fd &> /dev/null; then
    export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
fi

export FZF_CTRL_T_OPTS='
    --preview="cat {} 2>/dev/null | head -100"
    --preview-window=right:50%:wrap
    --bind="ctrl-/:toggle-preview"
'

# ===========================================
# ALT-C: Directory change
# ===========================================
if command -v fdfind &> /dev/null; then
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
elif command -v fd &> /dev/null; then
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

export FZF_ALT_C_OPTS='
    --preview="ls -la {} 2>/dev/null | head -20"
    --preview-window=right:50%:wrap
'

# ===========================================
# CTRL-R: History search
# ===========================================
export FZF_CTRL_R_OPTS='
    --preview="echo {}"
    --preview-window=down:3:wrap
    --bind="ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort"
    --header="Press CTRL-Y to copy command to clipboard"
'

# ===========================================
# Custom functions
# ===========================================

# fe: Edit file with fzf
fe() {
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# fh: Search command history
fh() {
    local cmd
    cmd=$(history | fzf +s --tac | sed 's/^ *[0-9]* *//')
    [ -n "$cmd" ] && eval "$cmd"
}

# fkill: Kill process with fzf
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m --header="Select process to kill" | awk '{print $2}')
    [ -n "$pid" ] && echo "$pid" | xargs kill -${1:-9}
}

# fgit: Git branch checkout with fzf
fgit() {
    local branch
    branch=$(git branch -a | fzf | sed 's/remotes\/origin\///' | xargs)
    [ -n "$branch" ] && git checkout "$branch"
}

# fgl: Git log with fzf
fgl() {
    git log --oneline --color=always | fzf --ansi --preview='git show --color=always {1}' --preview-window=right:60%
}

# fenv: Search environment variables
fenv() {
    local var
    var=$(printenv | fzf)
    [ -n "$var" ] && echo "$var"
}

# ===========================================
# Load fzf key bindings and completion
# ===========================================
# These are typically installed by fzf installer
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Manual loading if fzf is installed via package manager
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
if [ -f /usr/share/bash-completion/completions/fzf ]; then
    source /usr/share/bash-completion/completions/fzf
fi
