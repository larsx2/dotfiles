gwapr() {
    local pr=$(
        gh pr list --limit 100 --json number,title,headRefName,author \
            --jq '.[] | "\(.number)|\(.title)|\(.headRefName)|\(.author.login)"' |
        awk -F'|' '{
            # Cyan for PR number, yellow for branch, default for title and author
            printf "\033[36m#%s\033[0m %s \033[33m[%s]\033[0m (%s)\n", $1, $2, $3, $4
        }' |
        fzf --ansi --header="Select PR" --reverse
    )

    [[ -z $pr ]] && return

    # Strip ANSI codes for parsing
    local clean=$(echo "$pr" | sed 's/\x1b\[[0-9;]*m//g')

    # Extract PR number
    local pr_number=${clean#\#}
    pr_number=${pr_number%% *}

    # Extract branch name from between [ and ]
    local pr_branch=${clean#*\[}
    pr_branch=${pr_branch%%\]*}

    local folder="PR-${pr_number}"
    local main_path=$(git worktree list | head -1 | awk '{print $1}')
    local full_path="$main_path/.worktrees/$folder"

    if [[ -e "$full_path" ]]; then
        folder=$(gum input --placeholder "Folder name" --value="$folder")
        [[ -z "$folder" ]] && return
        folder="${folder//\//-}"
        full_path="$main_path/.worktrees/$folder"
        [[ -e "$full_path" ]] && { gum style --foreground 196 "Path $full_path already exists"; return 1; }
    fi

    # Fetch and checkout the PR branch
    git fetch origin "${pr_branch}"

    if ! git show-ref --verify --quiet "refs/heads/${pr_branch}"; then
        git worktree add "$full_path" -b "${pr_branch}" --track "origin/${pr_branch}" && \
        _GW_LAST="$PWD" && cd "$full_path"
    else
        git worktree add "$full_path" "${pr_branch}" 2>/dev/null || \
        git worktree add --force "$full_path" "${pr_branch}" && \
        _GW_LAST="$PWD" && cd "$full_path"
    fi
}
alias gwpr=gwapr

gwls() {
    local selected=$(git worktree list | awk '{
        full_path = $1
        folder = full_path
        gsub(/.*\//, "", folder)
        branch = $NF
        gsub(/[\[\]]/, "", branch)
        printf "%s\t\033[36m[%s]\033[0m → %s\n", full_path, branch, folder
    }' | fzf --ansi --with-nth=2.. --delimiter='\t' --header="Select worktree" --reverse)

    [[ -z "$selected" ]] && return

    local path=${selected%%$'\t'*}
    [[ -n "$path" ]] && _GW_LAST="$PWD" && cd "$path"
}
alias gwl=gwls

gwrm() {
    local wt_list=$(git worktree list)
    local main_path=$(echo "$wt_list" | head -1 | awk '{print $1}')

    # Format: full_path<TAB>display_string
    local selected=$(echo "$wt_list" | awk 'NR > 1 {
        full_path = $1
        folder = full_path
        gsub(/.*\//, "", folder)

        branch = ""
        status = ""

        if ($NF == "prunable") {
            status = " \033[33m(prunable)\033[0m"
            branch = $(NF-1)
        } else {
            branch = $NF
        }

        gsub(/[\[\]()]/, "", branch)
        if (branch == "") branch = "unknown"

        printf "%s\t\033[36m[%s]\033[0m → %s%s\n", full_path, branch, folder, status
    }' | fzf --ansi --with-nth=2.. --delimiter='\t' --header="Select worktree to remove" --reverse)

    [[ -z "$selected" ]] && return

    local worktree_path=${selected%%$'\t'*}
    local display=${selected#*$'\t'}
    local clean=$(echo "$display" | sed 's/\x1b\[[0-9;]*m//g')
    local branch=${clean#\[}
    branch=${branch%%\]*}

    [[ -z "$worktree_path" ]] && { gum style --foreground 196 "Could not resolve worktree path"; return 1; }

    _gw_delete "$worktree_path" "$branch" "$main_path" "$wt_list"
}

gwa() {
    local base=${1:-HEAD}

    # Get branches ordered by most recent commit
    local branch=$({
        echo "<new branch>"
        git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads refs/remotes |
        sed 's|^origin/||' |
        awk '!seen[$0]++'
    } | gum filter --placeholder "Filter branches...")

    [[ -z $branch ]] && return

    # Handle new branch creation
    if [[ $branch == "<new branch>" ]]; then
        branch=$(gum input --placeholder "New branch name")
        [[ -z $branch ]] && return
        local create_new=true
    else
        local create_new=false
    fi

    # Get folder name
    local folder_default="${branch//\//-}"
    local folder=$(gum input --placeholder "Folder name (default: $folder_default)")
    [[ -z $folder ]] && folder="$folder_default"
    folder="${folder//\//-}"

    local full_path="$PWD/.worktrees/$folder"

    # Check if path already exists
    if [[ -e $full_path ]]; then
        gum style --foreground 214 "✗ Path $full_path already exists!"
        return 1
    fi

    # Create worktree
    if [[ $create_new == true ]]; then
        gum confirm "Create worktree at $full_path for branch $branch from $base?" || return
        if git worktree add "$full_path" -b "$branch" "$base"; then
            _GW_LAST="$PWD" && cd "$full_path"
        else
            gum style --foreground 196 "✗ Failed to create worktree"
            return 1
        fi
    else
        gum confirm "Create worktree at $full_path for branch $branch?" || return
        if git worktree add "$full_path" "$branch"; then
            _GW_LAST="$PWD" && cd "$full_path"
        else
            gum style --foreground 196 "✗ Failed to create worktree"
            return 1
        fi
    fi
}

gwo() {
    if [[ -n "$_GW_LAST" && -d "$_GW_LAST" ]]; then
        local prev="$PWD"
        cd "$_GW_LAST"
        _GW_LAST="$prev"
    else
        echo "No previous worktree to jump to"
        return 1
    fi
}

gwn() {
    local worktrees=(${(f)"$(git worktree list | awk '{print $1}')"})
    local current=$(pwd)
    local len=${#worktrees}

    for i in {1..$len}; do
        if [[ "${worktrees[$i]}" == "$current" ]]; then
            local next=$((i + 1))
            [[ $next -gt $len ]] && next=1
            _GW_LAST="$PWD" && cd "${worktrees[$next]}"
            return
        fi
    done

    _GW_LAST="$PWD" && cd "${worktrees[1]}"
}

gwp() {
    local worktrees=(${(f)"$(git worktree list | awk '{print $1}')"})
    local current=$(pwd)
    local len=${#worktrees}

    for i in {1..$len}; do
        if [[ "${worktrees[$i]}" == "$current" ]]; then
            local prev=$((i - 1))
            [[ $prev -lt 1 ]] && prev=$len
            _GW_LAST="$PWD" && cd "${worktrees[$prev]}"
            return
        fi
    done

    _GW_LAST="$PWD" && cd "${worktrees[$len]}"
}

zw() {
    local session_name="$1"
    if [[ -z "$session_name" ]]; then
        echo "Usage: zw <session-name>"
        return 1
    fi

    # Check if already in a zellij session
    if [[ -n "$ZELLIJ" ]]; then
        echo "Error: Already in a Zellij session. Exit first or use a different terminal."
        return 1
    fi

    # Convert branch name to folder name (replace slashes with dashes)
    local folder_name="${session_name//\//-}"
    local worktree_path="$PWD/.worktrees/$folder_name"

    # Get the git root directory
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -z "$git_root" ]]; then
        echo "Error: Not in a git repository"
        return 1
    fi

    cd "$git_root"

    # Check if worktree is registered with git (exact match)
    local wt_list=$(git worktree list)
    if echo "$wt_list" | awk '{print $1}' | grep -qFx "$worktree_path"; then
        # Worktree is registered - verify directory exists
        if [[ -d "$worktree_path" ]]; then
            cd "$worktree_path"
            zellij attach -c "$session_name"
            return
        else
            # Registered but directory missing - clean up and recreate
            git worktree remove "$worktree_path" 2>/dev/null || true
            git worktree prune
        fi
    fi

    # Worktree doesn't exist - ensure directory is clean
    if [[ -e "$worktree_path" ]]; then
        echo "Error: $worktree_path exists but is not a registered worktree"
        echo "Please remove it manually or use a different session name"
        return 1
    fi

    # Create worktree
    if git show-ref --verify --quiet refs/heads/$session_name; then
        # Local branch exists
        git worktree add "$worktree_path" "$session_name"
    elif git show-ref --verify --quiet refs/remotes/origin/$session_name; then
        # Remote branch exists
        git worktree add "$worktree_path" "$session_name"
    else
        # Create new branch from HEAD
        git worktree add "$worktree_path" -b "$session_name" HEAD
    fi

    cd "$worktree_path"
    zellij attach -c "$session_name"
}

_gw_add() {
    local main_path="$1"

    local selection=$({
        echo "<new branch>"
        git for-each-ref --sort=-committerdate \
            --format='%(committerdate:format:%Y %b %d %H:%M:%S) | %(refname:short)' \
            refs/heads refs/remotes |
        sed 's|origin/||' |
        awk -F' \\| ' '!seen[$2]++'
    } | fzf --exact --reverse --no-sort --header="Select branch" \
            --bind='ctrl-j:down,ctrl-k:up,ctrl-p:ignore')

    [[ -z "$selection" ]] && return 1

    local branch create_new=false
    if [[ "$selection" == "<new branch>" ]]; then
        branch=$(gum input --placeholder "New branch name")
        [[ -z "$branch" ]] && return 1
        create_new=true
    else
        branch=${selection##*| }
    fi

    local folder_default="${branch//\//-}"
    local folder=$(gum input --placeholder "Folder name" --value="$folder_default")
    [[ -z "$folder" ]] && return 1
    folder="${folder//\//-}"

    local new_path="$main_path/.worktrees/$folder"

    [[ -e "$new_path" ]] && return 1

    local git_err
    if [[ "$create_new" == true ]]; then
        gum confirm "Create worktree at .worktrees/$folder for new branch $branch?" || return 1
        if ! git_err=$(git worktree add "$new_path" -b "$branch" HEAD 2>&1); then
            _gw_error=${git_err#fatal: }
            return 2
        fi
    else
        gum confirm "Create worktree at .worktrees/$folder for branch $branch?" || return 1
        if ! git_err=$(git worktree add "$new_path" "$branch" 2>&1); then
            _gw_error=${git_err#fatal: }
            return 2
        fi
    fi
    _GW_LAST="$PWD" && cd "$new_path"
}

_gw_fast_rm() {
    local dir="$1"
    local trash="/tmp/gw-trash-$$-$RANDOM"
    mkdir -p "$trash"
    local heavy_dirs=(node_modules .next dist .turbo .cache .output .nuxt .vite build coverage .parcel-cache)
    for d in "${heavy_dirs[@]}"; do
        [[ -d "$dir/$d" ]] && mv "$dir/$d" "$trash/$d" 2>/dev/null
    done
    { rm -rf "$trash" &>/dev/null & } 2>/dev/null
    disown 2>/dev/null
}

_gw_delete() {
    local worktree_path="$1"
    local branch="$2"
    local main_path="$3"

    [[ -z "$worktree_path" ]] && return 1
    [[ "$worktree_path" == "$main_path" ]] && return 1

    local wt_list=${4:-$(git worktree list)}
    local is_prunable=false
    [[ "$(echo "$wt_list" | grep -F "[$branch]")" == *prunable* ]] && is_prunable=true

    if $is_prunable; then
        gum confirm "Prune worktree for $branch?" || return 1
        cd "$main_path"
        git worktree prune
    else
        gum confirm "Remove worktree for $branch?" || return 1
        cd "$main_path"
        _gw_fast_rm "$worktree_path"
        if ! git worktree remove "$worktree_path" 2>/dev/null; then
            gum confirm "Has uncommitted changes. Force remove?" || return 1
            git worktree remove --force "$worktree_path"
        fi
    fi

    if [[ "$branch" != "main" && "$branch" != "master" ]]; then
        if git show-ref --verify --quiet "refs/heads/${branch}"; then
            if gum confirm "Also delete branch $branch?"; then
                git branch -D "$branch"
            fi
        fi
    fi
}

gw() {
    git rev-parse --git-dir &>/dev/null || return 1

    local wt_list main_path
    local status_msg=""
    local keys="enter:cd · ctrl-d:delete · ctrl-n:add · ctrl-r:pull · esc:quit"

    while true; do
        wt_list=$(git worktree list)
        main_path=$(echo "$wt_list" | head -1 | awk '{print $1}')

        # Format: full_path<TAB>display_string
        local list=$(echo "$wt_list" | awk -v main="$main_path" '{
            full_path = $1
            folder = full_path
            gsub(/.*\//, "", folder)

            branch = ""
            status = ""

            if ($NF == "prunable") {
                status = " \033[33m(prunable)\033[0m"
                branch = $(NF-1)
            } else {
                branch = $NF
            }
            gsub(/[\[\]]/, "", branch)
            if (branch == "") branch = "unknown"

            prefix = "  "
            if (full_path == main) prefix = "★ "

            printf "%s\t%s\033[36m[%s]\033[0m → %s%s\n", full_path, prefix, branch, folder, status
        }')

        [[ -z "$list" ]] && return 1

        local header="$keys"
        local fzf_extra=()
        if [[ -n "$status_msg" ]]; then
            header="${status_msg}"$'\n'"${keys}"
            local port=$((RANDOM % 10000 + 20000))
            fzf_extra=(--listen $port --bind "start:execute-silent(sleep 5 && curl -s -XPOST localhost:$port -d \"change-header($keys)\" 2>/dev/null)")
        fi

        local result=$(echo "$list" | fzf \
            --ansi \
            --exact \
            --reverse \
            --no-sort \
            --cycle \
            --with-nth=2.. \
            --delimiter='\t' \
            "${fzf_extra[@]}" \
            --bind='ctrl-j:down,ctrl-k:up,ctrl-p:ignore' \
            --header="$header" \
            --expect=ctrl-d,ctrl-n,ctrl-r)

        local key=$(echo "$result" | head -1)
        local selected=$(echo "$result" | sed -n '2p')

        status_msg=""

        [[ -z "$selected" ]] && { [[ -z "$key" ]] && return; continue }

        local wt_path=${selected%%$'\t'*}
        local display=${selected#*$'\t'}
        local clean=$(echo "$display" | sed 's/\x1b\[[0-9;]*m//g')
        local branch=${clean#*\[}
        branch=${branch%%\]*}

        case "$key" in
            ctrl-n)
                _gw_add "$main_path"
                case $? in
                    0) status_msg=$'\033[32m✓ Worktree created\033[0m' ;;
                    2) status_msg=$'\033[31m✗ '"$_gw_error"$'\033[0m' ;;
                esac
                ;;
            ctrl-d)
                _gw_delete "$wt_path" "$branch" "$main_path" "$wt_list" && status_msg=$'\033[32m✓ Removed '$branch$'\033[0m'
                ;;
            ctrl-r)
                if git -C "$wt_path" pull &>/dev/null; then
                    status_msg=$'\033[32m✓ Pulled '$branch$'\033[0m'
                else
                    status_msg=$'\033[31m✗ Pull failed for '$branch$'\033[0m'
                fi
                ;;
            *)
                if [[ -d "$wt_path" ]]; then
                    _GW_LAST="$PWD" && cd "$wt_path"
                else
                    status_msg=$'\033[33mPath does not exist (may need pruning)\033[0m'
                    continue
                fi
                return
                ;;
        esac
    done
}
