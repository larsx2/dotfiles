# Zsh Aliases — Agent Reference

Non-interactive commands for AI agents.

**Dual-mode functions** (zellij aliases) accept exact arguments to skip fzf.
**Interactive-only functions** (git, worktree, ft) use fzf/gum and have no
flag mode — raw command equivalents are listed below for each.

## Dependencies

These tools must be installed for the aliases to work:

| Tool | Used by | Check |
|------|---------|-------|
| `fzf` | All interactive pickers (agents avoid these) | `which fzf` |
| `gum` | Confirmation prompts (agents bypass with `-f` flags) | `which gum` |
| `zellij` | Session management | `which zellij` |
| `gh` | PR workflows (`gprls`, `gwpr`, `ftpr`) | `which gh` |
| `nvim` | File pickers that open editor | `which nvim` |
| `delta` | Git diff pager | `which delta` |

If a command fails silently, check the dependency first.

## Zellij sessions (`zellij-aliases.zsh`)

| Task | Command |
|------|---------|
| List sessions | `zls` |
| Start named session | `zs <name>` |
| Open project from ~/Code | `zp <name>` |
| Attach to session | `za <name>`, `zf <name>`, or `zlz <name>` |
| Delete session(s) | `zrm -f <name> [name2 ...]` |
| Delete all | `zellij delete-all-sessions -y` |

Notes:
- All functions use **exact name matching** for non-interactive use.
  Partial matches fall back to fzf. Agents should always use exact names.
- `za`/`zf`/`zlz` attach to existing sessions only.
  To create if not exists, use `zp <name>` (scoped to ~/Code)
  or `zellij attach <name> -c` directly.
- Always pass `-f` to `zrm` to skip confirmation and fzf.
- `zrm -f` force-kills active sessions before deleting.
- `zp <name>` creates a session named `<name>` with cwd `~/Code/<name>`.
  Attaches if it already exists.
- Do NOT use `znuke` unless explicitly asked by the user.

## Git (`git-aliases.zsh`)

Most git aliases use fzf and are not agent-safe. Use the aliases and
equivalents below.

**Agent-safe aliases:**

| Task | Command |
|------|---------|
| Diff vs main | `gdpr` |
| Stash unstaged only | `gtk` |
| View PR | `ghview` |
| Comment on PR | `ghcomm` |

**Equivalents for interactive aliases:**

| Interactive alias | Agent equivalent |
|-------------------|-----------------|
| `gb` (switch branch) | `git checkout <branch>` |
| `gprls` (checkout PR) | `gh pr checkout <number>` |
| `gstage` (stage files) | `git add <file> [file2 ...]` |
| `gunstage` (unstage files) | `git restore --staged <file>` |
| `gstfp` (pick modified file) | `git status --porcelain` then open file |
| `gcnfp` (pick conflict file) | `git diff --name-only --diff-filter=U` |
| `gcv` (browse commits) | `git log --oneline` |
| `gstv` (browse stashes) | `git stash list` |

## Worktrees (`worktree-aliases.zsh`)

The interactive aliases (`gw`, `gwa`, `gwls`, `gwrm`, `gwpr`) use fzf/gum
and are not agent-safe. Use the equivalent commands below instead.

| Task | Command |
|------|---------|
| List worktrees | `git worktree list` |
| cd to worktree | `cd .worktrees/<folder>` |
| Navigate worktrees | `gwn` (next), `gwp` (prev), `gwo` (toggle last) |
| Add worktree (existing branch) | `git worktree add .worktrees/<folder> <branch>` |
| Add worktree (new branch) | `git worktree add .worktrees/<folder> -b <branch> HEAD` |
| Add worktree from remote | `git fetch origin <branch> && git worktree add .worktrees/<folder> -b <branch> --track origin/<branch>` |
| Add worktree from PR | `gh pr checkout <number> -- -b .worktrees/pr-<number>` or see below |
| Remove worktree | `git worktree remove .worktrees/<folder>` |
| Force remove worktree | `git worktree remove --force .worktrees/<folder>` |
| Remove + delete branch | `git worktree remove --force .worktrees/<folder> && git branch -D <branch>` |
| Prune stale worktrees | `git worktree prune` |

**Worktree from PR (step by step):**

```sh
# Get the PR branch name
pr_branch=$(gh pr view <number> --json headRefName --jq '.headRefName')
# Fetch it
git fetch origin "$pr_branch"
# Create worktree
git worktree add ".worktrees/pr-<number>" -b "$pr_branch" --track "origin/$pr_branch"
# Or if local branch already exists
git worktree add ".worktrees/pr-<number>" "$pr_branch"
```

Notes:
- Worktrees are stored in `.worktrees/` at the repo root.
- `gwn`, `gwp`, `gwo` are non-interactive and safe for agents.
- For add/remove, prefer raw `git worktree` commands over the interactive aliases.

## Features / Tabs (`ft.zsh`)

Integrates zellij tabs with git worktrees. Session = project, tab = feature.

| Task | Command |
|------|---------|
| New feature | `ftn <name>` |
| Switch to feature tab | Use `zellij action go-to-tab-name <name>` directly |
| Close a tab | `zellij action close-tab` |

Notes:
- `ftn <name>` is non-interactive: creates worktree + branch + opens zellij tab.
- `ft`, `ftpr`, and `ftd` use fzf and are interactive — agents should avoid them.
- To delete a feature worktree non-interactively, use raw git commands:
  `git worktree remove --force .worktrees/<folder> && git branch -D <branch>`

## Worktree sessions (`~/.zc.sh`)

| Task | Command |
|------|---------|
| Create worktree + session | `zn <feature>` (non-interactive, requires not inside zellij) |
| Delete feature sessions | `zd` (interactive fzf — agents should use `zrm -f <name>` instead) |

## Docker (`docker-aliases.zsh`)

All docker aliases are non-interactive and agent-safe:

| Task | Command |
|------|---------|
| Compose up | `dupd` |
| Compose down | `ddown` |
| Compose stop | `dstop` |
| Compose start | `dstart` |
| Compose restart | `dreload` |
| Compose ps | `dps` |
| Compose logs | `dlogs` |
| Compose logs (follow) | `dlogsf` |
| Compose build | `dbuild` |
| Compose exec | `dexec <service> <cmd>` |
| Compose run | `drun <service> <cmd>` |
| Remove all containers | Do NOT use `dnuke` — use `docker rm -f $(docker ps -aq)` directly |

## General rules

- **Zellij aliases** are dual-mode: no args = fzf, exact args = direct.
  Agents should always pass exact names.
- **Git, worktree, and ft aliases** are interactive-only (fzf/gum).
  Agents should use the raw command equivalents documented above.
- **Docker aliases** are simple 1:1 mappings and always agent-safe.
- Confirmation prompts use `gum confirm`. Force flags (`-f`) bypass them.
- When in doubt, use the underlying tool directly (`git`, `zellij`, `docker`).

## Source locations

| File | Path |
|------|------|
| Zellij aliases | `~/.config/zsh/zellij-aliases.zsh` |
| Git aliases | `~/.config/zsh/git-aliases.zsh` |
| Worktree aliases | `~/.config/zsh/worktree-aliases.zsh` |
| Feature/tab aliases | `~/.config/zsh/ft.zsh` |
| Docker aliases | `~/.config/zsh/docker-aliases.zsh` |
| Worktree sessions | `~/.zc.sh` |

All sourced from `~/.zshrc`.
