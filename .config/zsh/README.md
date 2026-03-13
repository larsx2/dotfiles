# Zsh Config

Sourced from `~/.zshrc`. Each file is a self-contained module.

## Prerequisites

| Tool | Purpose | Install |
|------|---------|---------|
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder for all pickers | `brew install fzf` |
| [gum](https://github.com/charmbracelet/gum) | Pretty confirmation prompts | `brew install gum` |
| [zellij](https://zellij.dev) | Terminal multiplexer | `brew install zellij` |
| [gh](https://cli.github.com) | GitHub CLI (PR workflows) | `brew install gh` |
| [delta](https://github.com/dandavella/delta) | Git diff pager | `brew install git-delta` |
| [nvim](https://neovim.io) | Editor (used by git file pickers) | `brew install neovim` |

## Files

| File | Purpose |
|------|---------|
| `zellij-aliases.zsh` | Zellij session management |
| `git-aliases.zsh` | Git shortcuts with fzf |
| `worktree-aliases.zsh` | Git worktree management |
| `ft.zsh` | Zellij tabs + worktrees (session = project, tab = feature) |
| `docker-aliases.zsh` | Docker compose shortcuts |
| `zellij-completions.zsh` | Zellij tab completions (auto-generated) |

Also: `~/.zc.sh` — `zn` / `zd` for worktree-based zellij sessions.

## Quick reference

### Zellij sessions (`zellij-aliases.zsh`)

| Command | What it does |
|---------|-------------|
| `z` | Alias for `zellij` |
| `zp [name]` | Open project from `~/Code` (MRU fzf picker, fuzzy fallback) |
| `za [name]` | Attach to session (exact = direct, partial = fzf) |
| `zf [name]` | Same as `za` — fuzzy find session |
| `zls` | List sessions |
| `zs <name>` | Start a named session |
| `zrm [-f] [name]` | Delete sessions (fzf picker or exact match, `-f` for no prompts) |
| `zpwd` | Start session named after current directory |
| `znuke` | Delete all sessions (prompts) |

MRU history stored in `~/.cache/zp_history` (auto-trimmed to 500 entries).
Delete the file to reset ordering.

### Git (`git-aliases.zsh`)

**Branch switching:**

| Command | What it does |
|---------|-------------|
| `gb` | Switch branch via fzf (sorted by recent) |
| `gcof` | Same as `gb` with commit preview |
| `gprls` | Pick and checkout a PR branch via fzf |

**Diffing and reviewing:**

| Command | What it does |
|---------|-------------|
| `gdpr` | Diff current branch vs `origin/main` |
| `gdprf` | Pick changed files from PR diff, open in nvim |
| `gdpre` | Same as `gdprf` (edit variant) |
| `gdf <q>` | Fuzzy pick unstaged file to diff |
| `gdfc <q>` | Fuzzy pick staged file to diff |
| `gdv` | Diff in nvim (read-only) |

**File pickers:**

| Command | What it does |
|---------|-------------|
| `gstfp` | Pick modified files via fzf, open in nvim |
| `gcnfp` | Pick conflict files via fzf, open in nvim |
| `gdfp` | Pick staged files, open in nvim |
| `gdcap` | Pick unstaged/untracked files, open in nvim |

**Staging:**

| Command | What it does |
|---------|-------------|
| `gstage` | Pick unstaged files to stage (with diff preview) |
| `gunstage` | Pick staged files to unstage (with diff preview) |

**History:**

| Command | What it does |
|---------|-------------|
| `gcv` / `gcmv` | Browse commits via fzf with preview |
| `gstv` | Browse stashes via fzf with preview |
| `gtk` | Stash only unstaged changes (`git stash -k`) |

**GitHub:**

| Command | What it does |
|---------|-------------|
| `ghview` | View PR (`gh pr view`) |
| `ghcomm` | Comment on PR (`gh pr comment -e`) |

### Worktrees (`worktree-aliases.zsh`)

| Command | What it does |
|---------|-------------|
| `gw` | Interactive worktree manager (full TUI, see keybinds below) |
| `gwa [base]` | Add new worktree (pick branch or create new) |
| `gwls` / `gwl` | List and cd to worktree via fzf |
| `gwrm` | Remove worktree via fzf |
| `gwpr` | Create worktree from a PR |
| `gwo` | Jump back to previous worktree |
| `gwn` | Next worktree (cycle) |
| `gwp` | Previous worktree (cycle) |
| `zw <name>` | Create worktree + zellij session |

**`gw` keybinds (interactive TUI):**

| Key | Action |
|-----|--------|
| `enter` | cd into selected worktree |
| `ctrl-n` | Add new worktree |
| `ctrl-d` | Delete selected worktree |
| `ctrl-r` | Pull latest on selected worktree |
| `esc` | Quit |

### Features / Tabs (`ft.zsh`)

Integrates zellij tabs with git worktrees: **session = project, tab = feature**.

| Command | What it does |
|---------|-------------|
| `ft` | Switch to feature (worktree) via fzf — opens as zellij tab |
| `ftn <name>` | New feature: creates worktree + branch + opens tab |
| `ftpr` | New feature from PR: picks PR via fzf, creates worktree |
| `ftd` | Delete feature: closes tab + removes worktree + deletes branch |

### Worktree sessions (`~/.zc.sh`)

| Command | What it does |
|---------|-------------|
| `zn <feature>` | Create worktree + zellij session for feature work |
| `zd` | Delete feature sessions (fzf, filters `-XXXX` suffix pattern) |

### Docker (`docker-aliases.zsh`)

**Lifecycle:**

| Command | What it does |
|---------|-------------|
| `dc` | `docker compose` |
| `dupd` | `docker compose up -d` |
| `ddown` | `docker compose down` |
| `dstop` | `docker compose stop` |
| `dstart` | `docker compose start` |
| `dreload` | `docker compose restart` |
| `dkill` | `docker compose kill` |

**Info:**

| Command | What it does |
|---------|-------------|
| `dps` | `docker compose ps` |
| `dls` | `docker compose ls` |
| `dversion` | `docker compose version` |

**Logs:**

| Command | What it does |
|---------|-------------|
| `dlogs` | `docker compose logs` |
| `dlogsf` | `docker compose logs -f --tail=100` |
| `dtail` | `docker compose logs --tail=100` |
| `dtailn` | `docker compose logs --tail=` (append count) |

**Build and run:**

| Command | What it does |
|---------|-------------|
| `dbuild` | `docker compose build` |
| `drun` | `docker compose run` |
| `dexec` | `docker compose exec` |
| `drm` | `docker compose rm` |
| `dpull` | `docker compose pull` |
| `dpush` | `docker compose push` |

**Danger zone:**

| Command | What it does |
|---------|-------------|
| `dnuke` | Remove ALL containers (with gum confirm) |

---

## Usage

### Starting your day

```sh
# Pick a project to work on (MRU ordered, fzf picker)
zp

# Or jump straight to one you know
zp syntage-cli

# Partial match? Opens fzf pre-filtered
zp alle
```

### Working on features (tab workflow)

Best for: multiple features in the same project, staying in one zellij session.

```sh
# Inside a project session, start a new feature
ftn add-payment-flow
# → creates worktree + branch, opens as a new zellij tab

# Start a feature from a PR
ftpr
# → pick a PR via fzf, creates worktree, opens tab

# Switch between features
ft
# → fzf picker showing all worktrees (* = tab already open)

# Done with a feature — cleans up everything
ftd
# → closes tab, removes worktree, deletes branch
```

### Working on features (session workflow)

Best for: isolated feature work in a dedicated zellij session.

```sh
# From a project root, spin up a feature session
zn add-payment-flow
# → creates worktree + branch + new zellij session

# Clean up feature sessions when done
zd
# → fzf multi-select of feature sessions (the -XXXX suffix ones)
```

### Managing worktrees

```sh
# Interactive worktree manager — the power tool
gw
# → full TUI: browse worktrees, enter to cd, ctrl-n to add,
#   ctrl-d to delete, ctrl-r to pull, esc to quit

# Quick navigation
gwn          # next worktree
gwp          # previous worktree
gwo          # toggle between last two

# One-off operations
gwls         # list and pick via fzf
gwa          # add new worktree (branch picker + folder prompt)
gwrm         # remove worktree via fzf
gwpr         # create worktree from a PR
```

### Juggling sessions

```sh
# What's running?
zls

# Detach from current session (Ctrl+o → d), then pick another
za
# or
zf

# Fuzzy partial match
za domain
# → "domain" exact match? attaches directly
# → "domain" matches multiple? opens fzf pre-filtered
```

### Git workflow

```sh
# Switch branch (sorted by most recent)
gb

# Review PR changes
gdpr               # diff vs origin/main
gdprf              # pick changed files, open in nvim

# Stage interactively with diff preview
gstage             # pick files to stage
gunstage           # pick files to unstage

# Browse commits and stashes
gcv                # commit browser with preview
gstv               # stash browser with preview

# Checkout a PR branch
gprls
```

### Cleanup

```sh
# Delete specific sessions
zrm                # fzf multi-select
zrm domain         # partial match opens fzf
zrm -f old-thing   # force delete, no prompts (agent-friendly)

# Nuclear options
znuke              # delete all zellij sessions (prompts)
dnuke              # remove all docker containers (prompts)
```

---

All interactive functions support two modes:
- **Interactive** (no args or partial match) — fzf picker, `gum confirm` for destructive actions
- **Non-interactive** (exact name or `-f` flag) — direct execution, no prompts

See `AGENTS.md` for AI agent usage.
