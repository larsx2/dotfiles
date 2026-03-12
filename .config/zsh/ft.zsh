# ft.zsh - Zellij + Git Worktree integration
# Session = Project, Tab = Feature
#
# Commands:
#   ft        - Switch to a feature (worktree) via fzf
#   ftn NAME  - New feature: creates worktree + branch
#   ftpr      - Feature from PR: picks PR, creates worktree
#   ftd       - Delete feature: worktree + branch + zellij tab

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_ft_project_root() {
    git worktree list 2>/dev/null | head -1 | awk '{print $1}'
}

_ft_go() {
    local name="$1"
    local dir="$2"
    local open_tabs="${3-}"
    if [[ -n "$ZELLIJ" ]]; then
        [[ -z "$open_tabs" ]] && open_tabs=$(zellij action query-tab-names 2>/dev/null)
        if echo "$open_tabs" | grep -qFx "$name"; then
            zellij action go-to-tab-name "$name"
        else
            zellij action new-tab --name "$name"
            sleep 0.5
            zellij action write-chars " cd '${dir}' && clear"
            zellij action write 10
        fi
    else
        cd "$dir"
    fi
}

_ft_ensure_worktrees_dir() {
    local root="$1"
    local wt_dir="$root/.worktrees"

    [[ -d "$wt_dir" ]] && return 0

    mkdir -p "$wt_dir"

    if [[ -f "$root/.gitignore" ]]; then
        grep -q '^\.worktrees/?$' "$root/.gitignore" 2>/dev/null || \
            echo ".worktrees/" >> "$root/.gitignore"
    else
        echo ".worktrees/" > "$root/.gitignore"
    fi
}

# ---------------------------------------------------------------------------
# ft - Feature switcher
# ---------------------------------------------------------------------------
ft() {
    local root=$(_ft_project_root)
    [[ -z "$root" ]] && { echo "Not in a git repo"; return 1; }

    local open_tabs=""
    if [[ -n "$ZELLIJ" ]]; then
        open_tabs=$(zellij action query-tab-names 2>/dev/null)
    fi

    local -a wt_paths
    local -a wt_folders
    local -a display_lines

    local line wt_path branch folder marker
    while IFS= read -r line; do
        wt_path=$(echo "$line" | awk '{print $1}')
        branch=$(echo "$line" | awk '{print $NF}' | tr -d '[]')
        folder=$(basename "$wt_path")

        marker="  "
        if [[ -n "$open_tabs" ]] && echo "$open_tabs" | grep -qFx "$folder"; then
            marker="* "
        fi

        wt_paths+=("$wt_path")
        wt_folders+=("$folder")
        display_lines+=("$(printf '%s\033[36m[%s]\033[0m %s' "$marker" "$branch" "$folder")")
    done < <(git worktree list)

    (( ${#display_lines[@]} == 0 )) && { echo "No worktrees found"; return 1; }

    local selected_line
    selected_line=$(printf '%s\n' "${display_lines[@]}" | fzf --ansi --reverse --header="Select feature (* = tab open)" --no-sort)

    [[ -z "$selected_line" ]] && return 0

    local picked_folder
    picked_folder=$(echo "$selected_line" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $NF}')

    local wt_path="" tab_name=""
    for i in {1..${#wt_folders[@]}}; do
        if [[ "${wt_folders[$i]}" == "$picked_folder" ]]; then
            wt_path="${wt_paths[$i]}"
            tab_name="${wt_folders[$i]}"
            break
        fi
    done

    if [[ -z "$wt_path" || ! -d "$wt_path" ]]; then
        echo "Could not resolve worktree path"
        return 1
    fi

    _ft_go "$tab_name" "$wt_path" "$open_tabs"
}

# ---------------------------------------------------------------------------
# ftn - New feature (worktree + branch)
# ---------------------------------------------------------------------------
ftn() {
    local feature="$1"
    if [[ -z "$feature" ]]; then
        echo "Usage: ftn <feature-name>"
        return 1
    fi

    local root=$(_ft_project_root)
    [[ -z "$root" ]] && { echo "Not in a git repo"; return 1; }

    git rev-parse HEAD &>/dev/null || { echo "No commits yet. Make an initial commit first."; return 1; }

    _ft_ensure_worktrees_dir "$root"

    local wt_path="$root/.worktrees/$feature"

    if ! git worktree add "$wt_path" -b "$feature" HEAD; then
        return 1
    fi

    printf "  \033[32m✓\033[0m Worktree \033[36m%s\033[0m from %s\n" "$feature" "$(git rev-parse --short HEAD)"

    _ft_go "$feature" "$wt_path"
}

# ---------------------------------------------------------------------------
# ftpr - Feature from PR (worktree)
# ---------------------------------------------------------------------------
ftpr() {
    local root=$(_ft_project_root)
    [[ -z "$root" ]] && { echo "Not in a git repo"; return 1; }

    _ft_ensure_worktrees_dir "$root"

    local pr
    pr=$(gh pr list --limit 100 --json number,title,headRefName,author \
        --jq '.[] | "\(.number)|\(.title)|\(.headRefName)|\(.author.login)"' |
    awk -F'|' '{
        printf "\033[36m#%s\033[0m %s \033[33m[%s]\033[0m (\033[90m%s\033[0m)\n", $1, $2, $3, $4
    }' |
    fzf --ansi --header="Select PR" --reverse)

    [[ -z "$pr" ]] && return 0

    local clean
    clean=$(echo "$pr" | sed 's/\x1b\[[0-9;]*m//g')
    local pr_number
    pr_number=$(echo "$clean" | sed 's/^#\([0-9]*\).*/\1/')

    local pr_branch
    pr_branch=$(gh pr view "$pr_number" --json headRefName --jq '.headRefName')
    [[ -z "$pr_branch" ]] && { echo "Could not resolve PR branch"; return 1; }

    local safe_branch=${pr_branch//[\/\ ]/-}
    local folder="pr-${pr_number}-${safe_branch}"
    local wt_path="$root/.worktrees/$folder"

    if [[ -d "$wt_path" ]]; then
        printf "  \033[33m→\033[0m Worktree already exists\n"
        _ft_go "$folder" "$wt_path"
        return 0
    fi

    git fetch origin "$pr_branch"

    if ! git show-ref --verify --quiet "refs/heads/${pr_branch}"; then
        git worktree add "$wt_path" -b "${pr_branch}" --track "origin/${pr_branch}" || return 1
    else
        git worktree add "$wt_path" "${pr_branch}" 2>/dev/null || \
        git worktree add --force "$wt_path" "${pr_branch}" || return 1
    fi

    printf "  \033[32m✓\033[0m PR #%s → \033[36m%s\033[0m\n" "$pr_number" "$folder"

    _ft_go "$folder" "$wt_path"
}

# ---------------------------------------------------------------------------
# ftd - Delete feature (worktree + branch + zellij tab)
# ---------------------------------------------------------------------------
ftd() {
    local root=$(_ft_project_root)
    [[ -z "$root" ]] && { echo "Not in a git repo"; return 1; }

    local main_path="$root"

    local -a wt_paths
    local -a wt_folders
    local -a wt_branches
    local -a display_lines

    local line wt_path branch folder
    while IFS= read -r line; do
        wt_path=$(echo "$line" | awk '{print $1}')
        [[ "$wt_path" == "$main_path" ]] && continue
        branch=$(echo "$line" | awk '{print $NF}' | tr -d '[]')
        folder=$(basename "$wt_path")

        wt_paths+=("$wt_path")
        wt_folders+=("$folder")
        wt_branches+=("$branch")
        display_lines+=("$(printf '\033[36m[%s]\033[0m %s' "$branch" "$folder")")
    done < <(git worktree list)

    (( ${#display_lines[@]} == 0 )) && { echo "No feature worktrees to delete"; return 1; }

    local selected_line
    selected_line=$(printf '%s\n' "${display_lines[@]}" | fzf --ansi --reverse --header="Select feature to delete" --no-sort)

    [[ -z "$selected_line" ]] && return 0

    local picked_folder
    picked_folder=$(echo "$selected_line" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $NF}')

    local wt_path="" tab_name="" branch=""
    for i in {1..${#wt_folders[@]}}; do
        if [[ "${wt_folders[$i]}" == "$picked_folder" ]]; then
            wt_path="${wt_paths[$i]}"
            tab_name="${wt_folders[$i]}"
            branch="${wt_branches[$i]}"
            break
        fi
    done

    [[ -z "$wt_path" ]] && { echo "Could not resolve worktree"; return 1; }

    gum confirm "Delete feature $tab_name?" || return 0

    # Close zellij tab
    if [[ -n "$ZELLIJ" ]]; then
        local open_tabs
        open_tabs=$(zellij action query-tab-names 2>/dev/null)
        if echo "$open_tabs" | grep -qFx "$tab_name"; then
            zellij action go-to-tab-name "$tab_name"
            zellij action close-tab
            printf "  \033[32m✓\033[0m Closed tab\n"
        fi
    fi

    [[ "$PWD" == "$wt_path"* ]] && cd "$main_path"

    local trash=$(mktemp -d)
    local heavy_dirs=(node_modules .next dist .turbo .cache .output .nuxt .vite build coverage .parcel-cache)
    for d in "${heavy_dirs[@]}"; do
        [[ -d "$wt_path/$d" ]] && mv "$wt_path/$d" "$trash/$d" 2>/dev/null
    done

    git worktree remove --force "$wt_path" &>/dev/null
    printf "  \033[32m✓\033[0m Removed worktree\n"

    if [[ "$branch" != "main" && "$branch" != "master" ]]; then
        git branch -D "$branch" &>/dev/null
        printf "  \033[32m✓\033[0m Deleted branch %s\n" "$branch"
    fi

    { rm -rf "$trash" &>/dev/null & } 2>/dev/null
    disown 2>/dev/null

    printf "\n\033[32m✓ Done\033[0m\n"
}
