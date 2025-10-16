gwpr() {
    local pr=$(
        gh pr list --limit 100 --json number,title,headRefName,author --jq '.[]' |
        while IFS= read -r line; do
            local num=$(echo "$line" | jq -r '.number')
            local title=$(echo "$line" | jq -r '.title')
            local branch=$(echo "$line" | jq -r '.headRefName')
            local author=$(echo "$line" | jq -r '.author.login')
            
            printf "\033[33m#%-5s\033[0m %-50s \033[36m[%s]\033[0m \033[90m(%s)\033[0m\n" \
                "$num" "$title" "$branch" "$author"
        done | fzf --ansi --header "Select PR" --reverse
    )
    
    [[ -z $pr ]] && return
    
    # Strip colors and extract
    local pr_clean=$(echo "$pr" | sed 's/\x1b\[[0-9;]*m//g')
    local pr_number=${${pr_clean%%' '*}#'#'}
    local pr_branch=${${pr_clean#*\[}%%\]*}
    
    # Replace slashes and spaces with dashes
    local safe_branch=${pr_branch//[\/\ ]/-}
    local default_folder="pr-${pr_number}-${safe_branch}"
    
    local folder=$(gum input --placeholder "Folder name" --value="$default_folder")
    [[ -z $folder ]] && return
    
    local full_path="$HOME/.worktrees/$folder"
    
    if gum confirm "Create worktree at $full_path for PR #${pr_number}?"; then
        git fetch origin "pull/${pr_number}/head:pr-${pr_number}" && \
        git worktree add "$full_path" "pr-${pr_number}" && \
        cd "$full_path"
    fi
}

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
    
    # Replace slashes and spaces with dashes for folder name
    local safe_branch=${pr_branch//[\/\ ]/-}
    local default_folder="pr-${pr_number}-${safe_branch}"
    
    local folder=$(gum input --placeholder "Folder name" --value="$default_folder")
    [[ -z $folder ]] && return
    
    local full_path="$HOME/.worktrees/$folder"
    
    # Ask whether to sync to existing branch or create new one
    local branch_choice=$(gum choose "Use existing branch (${pr_branch})" "Create new branch (pr-${pr_number})")
    
    if gum confirm "Create worktree at $full_path for PR #${pr_number}?"; then
        if [[ $branch_choice == "Use existing branch"* ]]; then
            # Fetch the remote branch
            git fetch origin "${pr_branch}"
            
            # Create or reuse local branch, then add worktree with --force to detach if needed
            if ! git show-ref --verify --quiet "refs/heads/${pr_branch}"; then
                # Branch doesn't exist locally, create it
                git worktree add "$full_path" -b "${pr_branch}" --track "origin/${pr_branch}" && \
                cd "$full_path"
            else
                # Branch exists locally, force checkout (detaches from other worktrees if needed)
                git worktree add "$full_path" "${pr_branch}" 2>/dev/null || \
                git worktree add --force "$full_path" "${pr_branch}" && \
                cd "$full_path"
            fi
        else
            # Create a new local branch based on the PR
            git fetch origin "pull/${pr_number}/head:pr-${pr_number}" && \
            git worktree add "$full_path" "pr-${pr_number}" && \
            cd "$full_path"
        fi
    fi
}

gwls() {
    local selected=$(git worktree list | awk '{
        # Extract path (first field) and branch (last field in parens)
        path = $1
        gsub(/.*\//, "", path)  # Get folder name only
        branch = $NF
        gsub(/[\[\]]/, "", branch)  # Remove brackets
        # Cyan for branch, default for arrow and path
        printf "\033[36m[%s]\033[0m → %s\n", branch, path
    }' | fzf --ansi --header="Select worktree" --reverse)
    
    [[ -z $selected ]] && return
    
    # Strip ANSI codes and extract branch name
    local clean=$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g')
    local branch=${clean#\[}
    branch=${branch%%\]*}
    local path=$(git worktree list | awk -v b="$branch" '$NF == "["b"]" {print $1}')
    
    cd "$path"
}
alias gwl=gwls

gwrm() {
    local selected=$(git worktree list | awk 'NR > 1 {
        path = $1
        gsub(/.*\//, "", path)
        
        # Reset variables for each line
        branch = ""
        status = ""
        
        # Check if last field is "prunable"
        if ($NF == "prunable") {
            status = " \033[33m(prunable)\033[0m"
            # Branch is second-to-last field
            branch = $(NF-1)
        } else {
            # Branch is last field
            branch = $NF
        }
        
        # Remove brackets
        gsub(/[\[\]()]/, "", branch)
        
        if (branch == "") branch = "unknown"
        
        printf "\033[36m[%s]\033[0m → %s%s\n", branch, path, status
    }' | fzf --ansi --header="Select worktree to remove" --reverse)
    
    [[ -z $selected ]] && return
    
    # Extract branch name and check if prunable
    local clean=$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g')
    local branch=${clean#\[}
    branch=${branch%% *}
    branch=${branch%%\]*}
    
    local is_prunable="no"
    if echo "$clean" | grep -q "(prunable)"; then
        is_prunable="yes"
    fi
    
    # Get full path for this branch
    local worktree_path=$(git worktree list | grep "\[$branch\]" | awk '{print $1}')
    
    # Get primary worktree
    local main_path=$(git worktree list | head -1 | awk '{print $1}')
    
    if [[ $is_prunable == "yes" ]]; then
        if gum confirm "Prune worktree tracking for branch $branch?"; then
            cd "$main_path"
            git worktree prune
            gum style --foreground 212 "✓ Pruned worktree tracking!"
            gum style --foreground 33 "↩ Returned to main worktree"
            
            if [[ $branch != "main" && $branch != "master" && $branch != "unknown" ]]; then
                if git show-ref --verify --quiet "refs/heads/${branch}"; then
                    if gum confirm "Also delete branch $branch?"; then
                        git branch -D "$branch"
                        gum style --foreground 212 "✓ Branch deleted!"
                    fi
                fi
            fi
        fi
        return
    fi
    
    if gum confirm "Remove worktree for branch $branch?"; then
        if ! git worktree remove "$worktree_path" 2>/dev/null; then
            gum style --foreground 214 "⚠ Worktree has uncommitted changes!"
            if gum confirm "Force remove worktree (you'll lose uncommitted changes)?"; then
                cd "$main_path"
                git worktree remove --force "$worktree_path"
                gum style --foreground 212 "✓ Worktree force removed!"
                gum style --foreground 33 "↩ Returned to main worktree"
            else
                gum style --foreground 214 "✗ Cancelled."
                return
            fi
        else
            cd "$main_path"
            gum style --foreground 212 "✓ Worktree removed!"
            gum style --foreground 33 "↩ Returned to main worktree"
        fi
        
        if [[ $branch != "main" && $branch != "master" ]]; then
            if git show-ref --verify --quiet "refs/heads/${branch}"; then
                if gum confirm "Also delete branch $branch?"; then
                    git branch -D "$branch"
                    gum style --foreground 212 "✓ Branch deleted!"
                fi
            fi
        fi
    else
        gum style --foreground 214 "✗ Cancelled."
    fi
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
    
    local full_path="$HOME/.worktrees/$folder"
    
    # Check if path already exists
    if [[ -e $full_path ]]; then
        gum style --foreground 214 "✗ Path $full_path already exists!"
        return 1
    fi
    
    # Create worktree
    if [[ $create_new == true ]]; then
        gum confirm "Create worktree at $full_path for branch $branch from $base?" || return
        if git worktree add "$full_path" -b "$branch" "$base"; then
            cd "$full_path"
        else
            gum style --foreground 196 "✗ Failed to create worktree"
            return 1
        fi
    else
        gum confirm "Create worktree at $full_path for branch $branch?" || return
        if git worktree add "$full_path" "$branch"; then
            cd "$full_path"
        else
            gum style --foreground 196 "✗ Failed to create worktree"
            return 1
        fi
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
            cd "${worktrees[$next]}"
            return
        fi
    done
    
    cd "${worktrees[1]}"
}

gwp() {
    local worktrees=(${(f)"$(git worktree list | awk '{print $1}')"})
    local current=$(pwd)
    local len=${#worktrees}
    
    for i in {1..$len}; do
        if [[ "${worktrees[$i]}" == "$current" ]]; then
            local prev=$((i - 1))
            [[ $prev -lt 1 ]] && prev=$len
            cd "${worktrees[$prev]}"
            return
        fi
    done
    
    cd "${worktrees[$len]}"
}
