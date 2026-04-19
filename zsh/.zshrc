# Performance optimizations - put at the top
zmodload zsh/complist

# Deduplicate PATH entries automatically
typeset -U PATH

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Useful shell options
# setopt AUTO_CD
# setopt CORRECT
# setopt GLOB_DOTS
# setopt NO_BEEP
# setopt INTERACTIVE_COMMENTS

# Instant ESC in vi mode
KEYTIMEOUT=1

# Skip verification for faster startup
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Zsh-vi-mode config — MUST be set BEFORE sourcing oh-my-zsh
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEXT
ZVM_KEYTIMEOUT=0.01

# Oh My Zsh setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Disabled — Starship handles the prompt
export EDITOR="nvim"

# Optimized plugin loading
plugins=(
  git
  sudo
  dirhistory
  zsh-vi-mode
  zsh-autosuggestions
  zsh-syntax-highlighting
  # zsh-history-substring-search
  # zsh-fzf-history-search
)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# Configure zsh-autosuggestions BEFORE defining widgets
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
  fzf_file_widget
  fzf_custom_history_search
  fzf_cd_widget
  fzf_kill_widget
)

# Environment variables
export CLIPMENU_LAUNCHER="rofi -dmenu -i"
export BUN_INSTALL="$HOME/.bun"
export GEMINI_API_KEY=  # Add your key here

# PATH exports - all together, BUN_INSTALL defined above
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:~/.config/emacs/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH="$BUN_INSTALL/bin:$PATH"

# Fixed Java path - find your actual Java installation
# export JAVA_HOME=/usr/lib/jvm/default-java  # or wherever your Java is installed
# export PATH=$JAVA_HOME/bin:$PATH

# FZF configuration - optimized
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .wine --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview-window=right:50%:wrap'

#######################################################################################################################
# FZF WIDGETS - Fixed and working
#######################################################################################################################

# Smart file opener function
open_file_smart() {
  local file="$1"
  local ext="${file##*.}"
  
  case "$ext" in
    # Code files
    py|js|ts|jsx|tsx|html|css|scss|json|yaml|yml|toml|rs|go|cpp|c|h|hpp|java|kt|swift|php|rb|sh|zsh|bash|fish|vim|lua|md|txt|conf|config|ini|env) 
      nvim -- "$file" ;;
    
    # Video files
    mp4|mkv|avi|mov|wmv|flv|webm|m4v|3gp|ogv)
      mpv -- "$file" ;;
    
    # Audio files
    mp3|flac|wav|aac|ogg|m4a|wma|opus)
      mpv -- "$file" ;;
    
    # Images
    jpg|jpeg|png|gif|bmp|tiff|tif|svg|webp|ico)
      feh -- "$file" 2>/dev/null || xdg-open "$file" 2>/dev/null ;;
    
    # PDFs
    pdf)
      zathura -- "$file" 2>/dev/null || xdg-open "$file" 2>/dev/null ;;
    
    # Archives
    zip|tar|gz|bz2|xz|7z|rar)
      echo "Archive: $file"
      file -- "$file" ;;
    
    # Default: open with nvim for text files
    *)
      if file -- "$file" | grep -q "text"; then
        nvim -- "$file"
      fi ;;
  esac
}

# File widget with explicit fd command
fzf_file_widget() {
  # Clear buffer and autosuggestions
  zle kill-whole-line
  zle autosuggest-clear 2>/dev/null || true
  
  local file
  # Use fd command explicitly instead of relying on FZF_DEFAULT_COMMAND
  file=$(fd --type f --hidden --follow --exclude .wine --exclude .git --exclude node_modules | \
         fzf --height 40% \
             --layout=reverse \
             --prompt="📄 File > " \
             --border \
             --preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null || echo "Binary file or no preview available"' \
             --preview-window=right:50%:wrap)
  
  if [[ -n "$file" ]]; then
    local ext="${file##*.}"
    # Check if it's an unknown/executable file
    if [[ ! "$ext" =~ ^(py|js|ts|jsx|tsx|html|css|scss|json|yaml|yml|toml|rs|go|cpp|c|h|hpp|java|kt|swift|php|rb|sh|zsh|bash|fish|vim|lua|md|txt|conf|config|ini|env|mp4|mkv|avi|mov|wmv|flv|webm|m4v|3gp|ogv|mp3|flac|wav|aac|ogg|m4a|wma|opus|jpg|jpeg|png|gif|bmp|tiff|tif|svg|webp|ico|pdf|zip|tar|gz|bz2|xz|7z|rar)$ ]] || [[ -x "$file" ]] || file -- "$file" | grep -q "executable"; then
      # For unknown/executable files, put filename in command line buffer
      BUFFER="$file"
      CURSOR=$#BUFFER
    else
      # For known files, open them
      open_file_smart "$file"
    fi
  fi
  
  zle reset-prompt
}

# History search with better preview
fzf_custom_history_search() {
  zle autosuggest-clear 2>/dev/null || true
  setopt localoptions pipefail no_aliases 2> /dev/null
  
  local current_buffer=$BUFFER
  local selected=$(fc -rl 1 | 
                   awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
                   fzf --height 40% --reverse --tiebreak=index --query="$LBUFFER" \
                       --preview='echo {}' \
                       --preview-window=up:3:wrap)
  
  if [[ -n "$selected" ]]; then
    BUFFER=$(echo "$selected" | sed 's/^[ 0-9]*\*\{0,1\}[ ]*//')
    CURSOR=$#BUFFER
  else
    BUFFER="$current_buffer"
  fi
  
  zle redisplay
  return 0
}

# Directory navigation with eza preview
fzf_cd_widget() {
  zle autosuggest-clear 2>/dev/null || true
  local dir
  dir=$(fd --type d --hidden --exclude .git --exclude node_modules 2>/dev/null | \
    fzf --height 40% \
        --layout=reverse \
        --prompt="📁 Dir > " \
        --border \
        --preview 'eza --tree --icons --color=always --level=2 {} 2>/dev/null || ls -la --color=always {}' \
        --preview-window=right:50%:wrap)
  
  if [[ -n "$dir" ]]; then
    cd -- "$dir"
  fi
  zle reset-prompt
}

# Process killer with better formatting
fzf_kill_widget() {
  zle autosuggest-clear 2>/dev/null || true
  local pid
  pid=$(ps -eo pid,ppid,user,comm,cmd --sort=-%cpu | 
        fzf --multi --header="Select processes to kill" \
            --preview='echo {}' \
            --preview-window=up:3:wrap | 
        awk '{print $1}')
  
  if [[ -n "$pid" ]]; then
    echo $pid | xargs kill -15
    echo "Killed processes: $pid"
  fi
  zle reset-prompt
}

# Register widgets
zle -N fzf_file_widget
zle -N fzf_custom_history_search
zle -N fzf_cd_widget
zle -N fzf_kill_widget

# Initial keybindings
bindkey '^F' fzf_file_widget
bindkey '^R' fzf_custom_history_search
bindkey '^T' fzf_cd_widget
bindkey '^K' fzf_kill_widget

# Zsh-vi-mode compatibility - rebind after vi-mode initializes
zvm_after_init_commands+=(
  'bindkey "^F" fzf_file_widget'
  'bindkey "^R" fzf_custom_history_search'
  'bindkey "^T" fzf_cd_widget'
  'bindkey "^K" fzf_kill_widget'
)

#######################################################################################################################
# ALIASES - Cleaned up and organized
#######################################################################################################################

# Navigation & Basic Commands
alias c='clear'
alias cdc="cd && c"
alias f="yazi"

# Neovim
alias n="nvim"
alias nv="neovide"
alias np="NVIM_APPNAME=personal-nvim nvim"
alias nvimc="NVIM_APPNAME=NvChad nvim"
alias nviml="NVIM_APPNAME=LazyVim nvim"
alias nvima="NVIM_APPNAME=AstroNvim nvim"

# Development
alias e="emacsclient -c -a 'emacs'"
alias c.="cursor . &"

# Eza aliases (actively maintained fork of exa)
alias ls='eza --icons --color=always'
alias ll='eza -l --icons --color=always'
alias la='eza -la --icons --color=always'
alias lt='eza --tree --icons --color=always --level=2'
alias llt='eza -l --tree --icons --color=always --level=2'
alias lta='eza -a --tree --icons --color=always --level=2'
alias llta='eza -la --tree --icons --color=always --level=2'
alias lrs='eza -l --sort=recent --icons --color=always'
alias lss='eza -l --sort=size --icons --color=always'
alias lg='eza -l --git --icons --color=always'
alias lga='eza -la --git --icons --color=always'
alias tre='eza --tree --icons --color=always --level=3 --git-ignore'

# LazyGit
alias lgit='lazygit'

# Opencode
alias oc='opencode'

# CPU Freq
alias lowf='sudo cpupower frequency-set -u 1.7GHz'
alias highf='sudo cpupower frequency-set -u 3.0GHz'

#######################################################################################################################
# FUNCTIONS
#######################################################################################################################

# Neovim config switcher
function nvims() {
  items=("nvim" "LazyVim" "personal-nvim" "devnvim-2" "NvChad" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config > " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "nvim" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim "$@"
}

# Weather function
weather() {
  curl wttr.in/"$1"
}

# Directory info function
dirinfo() {
  echo "📁 $(pwd)"
  echo "📄 Files: $(find . -maxdepth 1 -type f | wc -l)"
  echo "📂 Directories: $(find . -maxdepth 1 -type d | wc -l)"
  echo "💾 Size: $(du -sh . | cut -f1)"
}

# Create directory and cd into it
mkcd() {
  mkdir -p -- "$1" && cd -- "$1"
}

# Universal archive extractor
extract() {
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a valid file" >&2
    return 1
  fi
  case "$1" in
    *.tar.bz2)  tar xjf "$1"    ;;
    *.tar.gz)   tar xzf "$1"    ;;
    *.tar.xz)   tar xJf "$1"    ;;
    *.tar.zst)  tar --zstd -xf "$1" ;;
    *.bz2)      bunzip2 "$1"    ;;
    *.rar)      unrar x "$1"    ;;
    *.gz)       gunzip "$1"     ;;
    *.tar)      tar xf "$1"     ;;
    *.tbz2)     tar xjf "$1"    ;;
    *.tgz)      tar xzf "$1"    ;;
    *.zip)      unzip "$1"      ;;
    *.Z)        uncompress "$1" ;;
    *.7z)       7z x "$1"       ;;
    *.xz)       unxz "$1"       ;;
    *.zst)      unzstd "$1"     ;;
    *)          echo "extract: unknown archive format '$1'" >&2; return 1 ;;
  esac
}

#######################################################################################################################
# INITIALIZATION - Load at the end
#######################################################################################################################

# Initialize tools
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
# source <(fzf --zsh)

# Load external sources
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Lazy-load NVM (saves ~300ms startup time)
export NVM_DIR="$HOME/.nvm"
_nvm_lazy_load() {
  unfunction nvm node npm npx 2>/dev/null
  source /usr/share/nvm/init-nvm.sh
}
nvm()  { _nvm_lazy_load; nvm "$@" }
node() { _nvm_lazy_load; node "$@" }
npm()  { _nvm_lazy_load; npm "$@" }
npx()  { _nvm_lazy_load; npx "$@" }

# Final keybindings - ensure they stick
bindkey -s ^b "nvims\n"
bindkey '^T' fzf_file_widget
