# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

#exporting editor
export EDITOR="nvim"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-vi-mode git zsh-autosuggestions zsh-syntax-highlighting sudo dirhistory zsh-history-substring-search zsh-fzf-history-search)
fpath+=${zsh_custom:-${zsh:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
ZVM_KEYTIMEOUT=0.01

#######################################################################################################################
# Reliable FZF history search widget with command preview
fzf_custom_history_search() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  
  # Save the current buffer content
  local current_buffer=$BUFFER
  
  # Run fzf with history as input
  local selected=$(fc -rl 1 | 
                   awk '{ cmd=$0; sub(/^[ \t]*[0-9]+\**[ \t]+/, "", cmd); if (!seen[cmd]++) print $0 }' |
                   fzf --height 40% --reverse --tiebreak=index --query="$LBUFFER" \
                       --preview='echo {}' \
                       --preview-window=up:3:wrap)
  
  # If a selection was made, put it on the command line
  if [[ -n "$selected" ]]; then
    # Extract the command from the history line (remove the history number prefix)
    BUFFER=$(echo "$selected" | sed 's/^[ 0-9]*\*\{0,1\}[ ]*//')
    CURSOR=$#BUFFER
  else
    # If nothing was selected, restore the original buffer
    BUFFER="$current_buffer"
  fi
  
  zle redisplay
  return 0
}

# Create the widget from the function
zle -N fzf_custom_history_search

# Bind Ctrl+R to our custom widget
bindkey '^R' fzf_custom_history_search

# If you're using zsh-vi-mode, also add this to make it work in vi-mode
if [[ -n "${ZSH_VI_MODE_PLUGIN}" || -n "${ZVM_INIT}" ]]; then
  zvm_after_init_commands+=('bindkey "^R" fzf_custom_history_search')
fi
zvm_after_init_commands+=('bindkey "^R" fzf_custom_history_search')

# Perfect directory navigation that works with zsh-vi-mode
fzf_cd_widget() {
  local dir
  dir=$(fd --type d --hidden . 2>/dev/null | \
    fzf --height 40% \
        --layout=reverse \
        --prompt="📁 Dir > " \
        --border \
        --preview 'ls -la --color=always {}' \
        --preview-window=right:50%:wrap)
  
  if [[ -n "$dir" ]]; then
    cd "$dir"
    zle reset-prompt
  fi
}

zle -N fzf_cd_widget
bindkey '^F' fzf_cd_widget

# THIS IS THE CRUCIAL LINE - uncomment and add this to make Ctrl+F work with zsh-vi-mode
zvm_after_init_commands+=('bindkey "^F" fzf_cd_widget')

# Interactive process killer
fzf_kill_widget() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
  fi
  zle reset-prompt
}
zle -N fzf_kill_widget
bindkey '^K' fzf_kill_widget  # Ctrl+K to select and kill processes
zvm_after_init_commands+=('bindkey "^K" fzf_kill_widget')

#######################################################################################################################



# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#for neovide
alias nv="neovide"

# Neovim distros and alias
alias n="nvim"
alias nvimp="NVIM_APPNAME=personal-nvim nvim"
alias np="NVIM_APPNAME=personal-nvim nvim"
alias nvimc="NVIM_APPNAME=NvChad nvim"
alias nviml="NVIM_APPNAME=LazyVim nvim"
alias nvima="NVIM_APPNAME=AstroNvim nvim"


function nvims() {
  items=("nvim" "LazyVim" "personal-nvim" "devnvim" "devnvim-2" "NvChad" "AstroNvim";)
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config > " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^b "nvims\n"
#---------------------------------------

eval $(thefuck --alias fuck)
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:~/.config/emacs/bin #for emacs
export PATH=$PATH:/home/swadesh/.cargo/bin #for cargo

#weather info in my terminal
weather() {
    curl wttr.in/"$1"
}

#clipmenu
export CLIPMENU_LAUNCHER="rofi -dmenu -i"
# exa alias
# Colorful and icon-rich aliases
alias ls='exa --icons --color=always'                  # Standard listing with icons and color
alias ll='exa -l --icons --color=always'               # Long format with icons and color
alias la='exa -la --icons --color=always'             # Long format with all files, icons, and color

# Tree views with icons and color
alias lt='exa --tree --icons --color=always'           # Tree view with icons and color
alias llt='exa -l --tree --icons --color=always'       # Long format tree view with icons and color
alias lta='exa -a --tree --icons --color=always'       # Tree view with all files, icons, and color
alias llta='exa -la --tree --icons --color=always'     # Long format tree with all files, icons, and color

# Sorted listings with icons and color
alias lrs='exa -l --sort=recent --icons --color=always'  # Recent modifications with icons and color
alias lss='exa -l --sort=size --icons --color=always'    # Size-sorted with icons and color

# Git-aware listings with icons and color
alias lg='exa -l --git --icons --color=always'         # Long format with Git status, icons, and color
alias lga='exa -la --git --icons --color=always'       # Long format with Git status, all files, icons, and color

#for zoxide or modern z
eval "$(zoxide init zsh)"

#for clear to cl
alias c='clear'
#alias for yazi or file manager
alias f="yazi"
#alias for emacs terminal mode
alias e="emacsclient -c -a 'emacs'"

#for starship
eval "$(starship init zsh)"

# for cd and c in one command
alias cdc="cd && c"

#for cursor editor
alias c.="cursor . &"

# # for pomodoro
# declare -A pomo_options
# pomo_options["work"]="45"
# pomo_options["break"]="10"
#
# pomodoro () {
#   if [ -n "$1" -a -n "${pomo_options["$1"]}" ]; then
#   val=$1
#   echo $val | lolcat
#   timer ${pomo_options["$val"]}m
#   spd-say "'$val' session done"
#   fi
# }
#
# alias wo="pomodoro 'work'"
# alias br="pomodoro 'break'"

source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .wine'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# bun completions
[ -s "/home/swadesh/.bun/_bun" ] && source "/home/swadesh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# gemenie api
export GEMINI_API_KEY=
source /usr/share/nvm/init-nvm.sh

export TERM=xterm-ghostty

export JAVA_HOME=/bin/java

