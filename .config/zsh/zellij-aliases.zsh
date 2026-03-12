# Zellij aliases
alias z="zellij"
alias zls="z ls"
alias za="zlz"
alias zf="zlz"
alias zpwd='z -n default -s $(basename $PWD)'
alias znuke="z delete-all-sessions"
alias zs="z -s"

# zp - Open/attach to a project session from ~/Code
# Usage: zp              → fzf picker (ordered by most recently used)
#        zp <project>    → direct (falls back to fzf with query if no exact match)
#
# Tracks usage history in ~/.cache/zp_history for MRU ordering.
zp() {
  if [[ -n "$ZELLIJ" ]]; then
    echo "⚠️  Already inside a zellij session."
    return 1
  fi

  [[ ! -d "$HOME/Code" ]] && echo "❌ ~/Code not found." && return 1

  local project="$1"
  local fzf_query=""
  local history_file="$HOME/.cache/zp_history"

  if [[ -n "$project" && -d "$HOME/Code/$project" ]]; then
    # Exact match — skip fzf
    :
  else
    # Build MRU-sorted project list:
    # 1. Recent projects from history (most recent first, deduplicated)
    # 2. Remaining projects alphabetically
    local all_projects
    all_projects=$(for d in ~/Code/*/; do basename "$d"; done)

    local sorted_projects
    if [[ -f "$history_file" ]]; then
      local recent
      recent=$(awk '{lines[NR]=$0} END{for(i=NR;i>=1;i--) if(!seen[lines[i]]++) print lines[i]}' "$history_file")
      # Recent first (only if dir still exists), then the rest alphabetically
      sorted_projects=$(
        echo "$recent" | while read -r p; do
          echo "$all_projects" | grep -qxF "$p" && echo "$p"
        done
        echo "$all_projects" | sort | while read -r p; do
          echo "$recent" | grep -qxF "$p" || echo "$p"
        done
      )
    else
      sorted_projects=$(echo "$all_projects" | sort)
    fi

    # No arg or no exact match — use fzf (with arg as initial query if provided)
    [[ -n "$project" ]] && fzf_query="$project"
    project=$(echo "$sorted_projects" | sed $'s/.*/\033[1;36m&\033[0m/' | fzf --ansi --height=~50% --layout=reverse --header="Select project" --query="$fzf_query" | sed 's/\x1b\[[0-9;]*m//g')
    [[ -z "$project" ]] && return 0
  fi

  # Record usage (trim to last 500 entries to prevent unbounded growth)
  mkdir -p "$(dirname "$history_file")"
  echo "$project" >> "$history_file"
  if [[ $(wc -l < "$history_file") -gt 500 ]]; then
    local tmp=$(mktemp)
    tail -n 500 "$history_file" > "$tmp" && mv "$tmp" "$history_file"
  fi

  zellij attach "$project" -c options --default-cwd "$HOME/Code/$project"
}

# zlz - Attach to an active session
# Usage: zlz              → fzf picker
#        zlz <session>    → direct attach (fzf if multiple matches)
zlz() {
  if [[ -n "$ZELLIJ" ]]; then
    echo "⚠️  Cannot switch sessions from inside Zellij."
    return 1
  fi

  local sessions_full sessions_short
  sessions_full=$(zellij list-sessions 2>/dev/null)
  sessions_short=$(zellij list-sessions -s 2>/dev/null)

  if [[ -z "$sessions_short" ]]; then
    echo "✨ No Zellij sessions found."
    return 1
  fi

  local session="$1"

  if [[ -n "$session" ]]; then
    # Exact match — attach directly
    if echo "$sessions_short" | grep -qxF "$session"; then
      zellij attach "$session"
      return $?
    fi

    # Partial match — fall back to fzf with query (full output for context)
    if ! echo "$sessions_short" | grep -qF "$session"; then
      echo "❌ No sessions matching: $session"
      return 1
    fi

    local selected
    selected=$(echo "$sessions_full" | fzf --ansi --no-preview --height=~50% --layout=reverse --query="$session")
    [[ -z "$selected" ]] && return 0
    zellij attach "$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')"
    return $?
  fi

  # No arg — full fzf picker (rich output)
  local selected
  selected=$(echo "$sessions_full" | fzf --ansi --no-preview --height=~50% --layout=reverse)
  [[ -z "$selected" ]] && return 0

  zellij attach "$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')"
}

# zrm - Delete sessions
# Usage: zrm                      → fzf multi-select + confirm
#        zrm <query>              → exact match deletes (with confirm), partial opens fzf
#        zrm -f <session> [...]   → force delete, no confirmation (agent-friendly, exact names only)
zrm() {
  local force=false
  if [[ "$1" == "-f" ]]; then
    force=true
    shift
  fi

  # Force mode: exact names only, no fzf, no confirmation (agent-friendly)
  if [[ "$force" == true ]]; then
    for session in "$@"; do
      zellij delete-session -f "$session" 2>/dev/null \
        && echo "✅ $session" \
        || echo "❌ $session"
    done
    return
  fi

  local sessions_full sessions_short
  sessions_full=$(zellij list-sessions 2>/dev/null)
  sessions_short=$(zellij list-sessions -s 2>/dev/null)

  if [[ -z "$sessions_short" ]]; then
    echo "✨ No Zellij sessions found."
    return 1
  fi

  local selected=""

  if [[ $# -gt 0 ]]; then
    local query="$1"

    # Exact match — use it directly
    if echo "$sessions_short" | grep -qxF "$query"; then
      selected="$query"
    else
      # Partial match — fall back to fzf with query
      if ! echo "$sessions_short" | grep -qF "$query"; then
        echo "❌ No sessions matching: $query"
        return 1
      fi

      selected=$(echo "$sessions_full" | fzf --ansi --no-preview --height=~50% --layout=reverse --multi --query="$query" --header="Select session(s) to delete (TAB to multi-select)")
      [[ -z "$selected" ]] && return 0
      selected=$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
    fi
  else
    # No arg — full fzf picker
    selected=$(echo "$sessions_full" | fzf --ansi --no-preview --height=~50% --layout=reverse --multi --header="Select session(s) to delete (TAB to multi-select)")
    [[ -z "$selected" ]] && return 0
    selected=$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
  fi

  echo "Sessions to delete:"
  echo "$selected" | awk '{print "  - " $0}'
  echo ""

  if gum confirm "Delete these sessions?"; then
    echo "$selected" | while read -r session_name; do
      zellij delete-session -f "$session_name" 2>/dev/null \
        && echo "  ✅ $session_name" \
        || echo "  ❌ $session_name"
    done
  else
    echo "👋 Cancelled."
  fi
}
