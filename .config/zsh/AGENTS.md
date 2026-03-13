# Zsh Aliases — Agent Reference

Non-interactive commands for AI agents. All commands avoid fzf and
interactive prompts when given exact arguments.

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

Most git aliases use fzf and are interactive. Agent-safe commands:

| Task | Command |
|------|---------|
| Diff vs main | `gdpr` |
| List changed files vs main | `git diff --name-only origin/main...HEAD` |
| Stash unstaged only | `gtk` |
| View PR | `ghview` |
| Comment on PR | `ghcomm` |

For staging, committing, and branching, agents should use `git` directly
rather than the fzf-based aliases.

## Worktrees (`worktree-aliases.zsh`)

Most worktree commands are interactive (fzf/gum). Agent-safe commands:

| Task | Command |
|------|---------|
| List worktrees | `git worktree list` |
| Add worktree (existing branch) | `git worktree add .worktrees/<folder> <branch>` |
| Add worktree (new branch) | `git worktree add .worktrees/<folder> -b <branch> HEAD` |
| Remove worktree | `git worktree remove .worktrees/<folder>` |
| Force remove worktree | `git worktree remove --force .worktrees/<folder>` |
| Navigate worktrees | `gwn` (next), `gwp` (prev), `gwo` (toggle last) |

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

- Confirmation prompts use `gum confirm`. Force flags (`-f`) bypass them.
- Functions with fzf fall back to interactive mode on partial matches.
  Agents must use exact names to stay non-interactive.
- When in doubt, use the underlying tool directly (`git`, `zellij`, `docker`)
  rather than the aliases.

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
