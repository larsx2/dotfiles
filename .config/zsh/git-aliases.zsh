export GIT_PAGER="bat --style grid,numbers"

export FZF_DEFAULT_OPTS=$'--bind=ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,ctrl-b:preview-page-up,ctrl-f:preview-page-down,alt-k:preview-up,alt-j:preview-down'

alias gb="git branch --sort=-committerdate --format='%(committerdate:format:%Y %b %d %H:%M:%S) | %(refname:short)' \
  | fzf --ansi --reverse \
  | cut -d'|' -f2 \
  | xargs git checkout"
alias gdpr="git diff origin/main...HEAD"
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
alias gunstage="git status --porcelain | grep '^[MADRCU]' | cut -c4- \
  | fzf -m --preview 'git diff --cached --color=always -- {}' \
  | xargs -r git restore --staged --"

# git staged file pick with preview
alias gdfp="git diff --cached --name-only \
  | fzf -m --preview 'git diff --cached --color=always -- {}' \
  | xargs -r -o nvim"

# git unstaged file pick with preview
alias gdcap="git status --porcelain | egrep '^ [^ ]|^\?\?' | cut -c4- \
  | fzf -m --preview 'git diff --color=always -- {}' \
  | xargs -r nvim"

# pick and edit file from pr change
alias gdpre='git diff --name-only origin/main...HEAD | fzf -m --preview "git diff origin/main...HEAD --color=always -- {}" | xargs -r nvim'

# only stash the non-staged
alias gtk="git stash -k"

# pick branch by most recent with commit preview
alias gcof="git branch --sort=-committerdate --format='%(committerdate:iso-strict) %(refname:short)' \
  | fzf --reverse --ansi --delimiter=' ' --with-nth=2.. \
        --preview 'git log -n 5 --oneline --graph --decorate --color=always {2}' \
  | cut -d' ' -f2 \
  | xargs git checkout"

