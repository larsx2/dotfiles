# Zsh Config

Sourced from `~/.zshrc`. Each file is a self-contained module.

## Files

| File | Purpose |
|------|---------|
| `git-aliases.zsh` | Git shortcuts |
| `docker-aliases.zsh` | Docker shortcuts |
| `worktree-aliases.zsh` | Git worktree shortcuts |
| `zellij-aliases.zsh` | Zellij session management |
| `zellij-completions.zsh` | Zellij tab completions (auto-generated) |
| `ft.zsh` | ft utility |

## Zellij quick reference

| Command | What it does |
|---------|-------------|
| `z` | Alias for `zellij` |
| `zs <name>` | Start a named session |
| `za [name]` | Attach to session (exact match direct, partial opens fzf) |
| `zf [name]` | Same as `za` — fuzzy find and attach to session |
| `zls` | List sessions |
| `zp [name]` | Open project from `~/Code` (MRU-ordered fzf, fuzzy fallback if no exact match) |
| `zlz [name]` | Same as `za`/`zf` — attach to active session |
| `zrm [-f] [name]` | Delete sessions (exact match or fzf, `-f` skips fzf + confirmation) |
| `zpwd` | Start session named after current directory |
| `znuke` | Delete all sessions (prompts for confirmation) |

All functions support two modes:
- **Interactive** (no args or partial match) — fzf picker with `gum confirm` for destructive actions
- **Non-interactive** (exact name or `-f` flag) — direct execution, no prompts

See `AGENTS.md` for AI agent usage.
See `~/.zc.sh` for `zn` (worktree+session) and `zd` (delete worktree sessions).
