gwrm() {
    local selected
    selected=$(git worktree list | gum choose --header="Select worktree to remove:")
    
    [[ -z $selected ]] && return
    
    local local_path=${selected%% *}
    
    # Get branch name for this worktree
    local branch=$(git worktree list --porcelain | awk -v path="$local_path" '
        $1 == "worktree" && $2 == path {found=1; next} 
        found && $1 == "branch" {sub(/^refs\/heads\//, "", $2); print $2; exit}
    ')
    
    if gum confirm "Remove worktree at: $local_path?"; then
        if ! git worktree remove "$local_path" 2>/dev/null; then
            gum style --foreground 214 "⚠ Worktree has uncommitted changes!"
            if gum confirm "Force remove worktree (you'll lose uncommitted changes)?"; then
                git worktree remove --force "$local_path"
                gum style --foreground 212 "✓ Worktree force removed!"
            else
                gum style --foreground 214 "✗ Cancelled."
                return
            fi
        else
            gum style --foreground 212 "✓ Worktree removed!"
        fi
        
        # Ask to delete PR branches
        if [[ -n $branch && $branch == pr-* ]]; then
            if gum confirm "Also delete branch $branch?"; then
                git branch -D "$branch"
                gum style --foreground 212 "✓ Branch deleted!"
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
        sed 's|origin/||' | 
        awk '!seen[$0]++'
    } | gum filter --placeholder "Filter branches...")
    
    [[ -z $branch ]] && return
    
    # Handle new vs existing branch
    if [[ $branch == "<new branch>" ]]; then
        branch=$(gum input --placeholder "New branch name")
        [[ -z $branch ]] && return
        local flags=(-b)
        local base_arg=($base)
    else
        local flags=()
        local base_arg=()
    fi
    
    # Replace slashes with dashes for folder name
    local folder=$(gum input --placeholder "Folder name" --value="${branch//\//-}")
    [[ -z $folder ]] && return
    
    local full_path="../$folder"
    
    gum confirm "Create worktree at $full_path for branch $branch${base:+ from $base}?" && \
        git worktree add "$full_path" $flags $branch $base_arg && \
        cd "$full_path"
}

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
    
    local full_path="../$folder"
    
    if gum confirm "Create worktree at $full_path for PR #${pr_number}?"; then
        git fetch origin "pull/${pr_number}/head:pr-${pr_number}" && \
        git worktree add "$full_path" "pr-${pr_number}" && \
        cd "$full_path"
    fi
}

gwapr() {
    local pr=$(
        gh pr list --limit 100 --json number,title,headRefName,author \
            --jq '.[] | "#\(.number) - \(.title) [\(.headRefName)] (\(.author.login))"' |
        gum filter --placeholder "Filter PRs..." --fuzzy=false
    )
    
    [[ -z $pr ]] && return
    
    # Extract PR number
    local pr_number=${${pr%%' '*}#'#'}
    
    # Extract branch name from between [ and ]
    local pr_branch=${${pr#*\[}%%\]*}
    
    # Replace slashes and spaces with dashes for folder name
    local safe_branch=${pr_branch//[\/\ ]/-}
    local default_folder="pr-${pr_number}-${safe_branch}"
    
    local folder=$(gum input --placeholder "Folder name" --value="$default_folder")
    [[ -z $folder ]] && return
    
    local full_path="../$folder"
    
    if gum confirm "Create worktree at $full_path for PR #${pr_number}?"; then
        # Fetch PR and create worktree in one go
        git fetch origin "pull/${pr_number}/head:pr-${pr_number}" && \
        git worktree add "$full_path" "pr-${pr_number}" && \
        cd "$full_path"
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
    }' | fzf --ansi --header="Select worktree")
    
    [[ -z $selected ]] && return
    
    # Strip ANSI codes and extract branch name
    local clean=$(echo "$selected" | sed 's/\x1b\[[0-9;]*m//g')
    local branch=${clean#\[}
    branch=${branch%%\]*}
    local path=$(git worktree list | awk -v b="$branch" '$NF == "["b"]" {print $1}')
    
    cd "$path"
}
alias gwl=gwls
