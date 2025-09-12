# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell" # set by `omz`

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshrc="nvim ~/.zshrc"
alias nvim-init="nvim ~/.config/nvim/lua/plugins/init.lua"
alias nvim-mappings="nvim ~/.config/nvim/lua/mappings.lua"
alias view="nvim -R"
alias z="zellij"

# https://github.com/zellij-org/zellij/issues/1933#issuecomment-2274464004
autoload -U +X compinit && compinit
. <( zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' )
# alias ohmyzsh="mate ~/.oh-my-zsh"

if [ "$(uname -m)" = "arm64" ]; then
  export DOCKER_DEFAULT_PLATFORM=linux/arm64
else
  export DOCKER_DEFAULT_PLATFORM=linux/amd64
fi


######################
####### DOCKER #######
######################
alias dc="docker compose"
alias dupd="docker compose up -d"
alias ddown="docker compose down"
alias dstop="docker compose stop"
alias dps="docker compose ps"
alias dls="docker compose ls"
alias dlogs="docker compose logs"
alias dlogsf="docker compose logs -f --tail=100"
alias dtail="docker compose logs --tail=100"
alias dtailn="docker compose logs --tail="
alias dtailf="docker compose logs -f --tail=100"
alias dbuild="docker compose build"
alias drm="docker compose rm"
alias drun="docker compose run"
alias dexec="docker compose exec"
alias dpull="docker compose pull"
alias dpush="docker compose push"
alias dversion="docker compose version"
alias dreload="docker compose restart"
alias dkill="docker compose kill"
alias dstart="docker compose start"
alias dstop="docker compose stop"
dnuke() {
  ids=$(docker ps -aq)
  [ -z "$ids" ] && return 0
  docker rm -fv $ids >/dev/null 2>&1 || true   # -f stops running containers; -v removes anon volumes
}

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load zsh-z
ZSH_Z_PATH=~/Code/zsh-z/zsh-z.plugin.zsh
[ -f $ZSH_Z_PATH ] && source $ZSH_Z_PATH

#####################
######## AWS ########
#####################
export AWS_PAGER=
export AWS_DEFAULT_OUTPUT=yaml-stream

#####################
#### GIT ALIASES ####
#####################

export GIT_PAGER="bat --style grid,numbers"

alias gb="git branch | fzf"
alias gdpr="git diff origin/main...HEAD"
export FZF_DEFAULT_OPTS=$'--bind=ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,alt-k:preview-up,alt-j:preview-down'

alias gdprf='git diff --name-only origin/main...HEAD \
  | fzf -m --ansi \
      --preview "git --no-pager diff --color=always origin/main...HEAD -- {}" \
  | xargs -r -o nvim'

# git status file pick with preview (porcelain safe)
alias gstfp="git status --porcelain \
  | cut -c4- \
  | fzf -m --preview 'git diff --color=always -- {}' \
  | xargs -r nvim"

# git conflict file pick
alias gcnfp='git diff --name-only --diff-filter=U | fzf -m | xargs nvim'

# git commit view
alias gcv="git log --oneline \
  | fzf -m --layout=reverse --preview 'git show --color=always {1}' \
  | awk '{print \$1}' \
  | xargs -r git show"
alias gcmv="gcv"

# git stash pick (with preview)
alias gstv="git stash list --pretty='%gd %cr %s' \
  | fzf -m --preview 'git stash show -p --color=always {1}' \
  | awk '{print \$1}' \
  | xargs -r -n1 git stash show -p --color=always"

# git unstaged file pick -> stage (with preview)
alias gstage="git status --porcelain | grep '^ [^ ]' | cut -c4- \
  | fzf -m --preview 'git diff --color=always -- {}' \
  | xargs -r git add --"

# git staged file pick → unstage (with preview)
alias gunstage="git status --porcelain | grep '^[^ ]' | cut -c4- \
  | fzf -m --preview 'git diff --cached --color=always -- {}' \
  | xargs -r git restore --staged --"

# git staged file pick with preview
alias gdfp="git diff --cached --name-only \
  | fzf -m --preview 'git diff --cached --color=always -- {}' \
  | xargs -r -o nvim"

# git unstaged file pick with preview
alias gdcafp="git status --porcelain | egrep '^ [^ ]|^\?\?' | cut -c4- \
  | fzf -m --preview 'git diff --color=always -- {}' \
  | xargs -r nvim"

# pick and edit file from pr change
alias gdpre='nvim $(git diff --name-only origin/main...HEAD | fzf -m)'

# only stash the non-staged
alias gtk="git stash -k"

# pick branch by most recent with commit preview
alias gcof="git branch --sort=-committerdate --format='%(committerdate:iso-strict) %(refname:short)' \
  | fzf --reverse --ansi --delimiter=' ' --with-nth=2.. \
        --preview 'git log -n 5 --oneline --graph --decorate --color=always {2}' \
  | cut -d' ' -f2 \
  | xargs git checkout"
