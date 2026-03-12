# Zsh Zellij Aliases — Agent Reference

Non-interactive commands for AI agents. All commands avoid fzf and
interactive prompts when given exact arguments.

## Session lifecycle

| Task | Command |
|------|---------|
| List sessions | `zls` |
| Start named session | `zs <name>` |
| Open project from ~/Code | `zp <name>` |
| Attach to session | `zlz <name>`, `za <name>`, or `zf <name>` |
| Delete session(s) | `zrm -f <name> [name2 ...]` |
| Delete all | `znuke` (prompts — use `zellij delete-all-sessions -y` to skip) |

## Important

- All functions use **exact name matching** for non-interactive use.
  If the name doesn't match exactly, they fall back to fzf (interactive).
  Agents should always use exact names.
- `za` is an alias for `zlz`. Both attach to existing sessions only.
  To create a session if it doesn't exist, use `zp <name>` (scoped to ~/Code)
  or `zellij attach <name> -c` directly.
- Always pass `-f` to `zrm` to skip confirmation prompts and fzf.
- `zrm -f` force-kills active sessions before deleting. It does not
  require sessions to exist — failed deletes are reported individually.
- `zp <name>` creates a session named `<name>` with cwd `~/Code/<name>`.
  Attaches if the session already exists.
- Do NOT use `znuke` unless explicitly asked by the user.
- Worktree-based sessions use `zn`/`zd` in `~/.zc.sh`, not these aliases.
- Confirmation prompts use `gum confirm`. Force flags (`-f`) bypass them.

## Source location

`~/.config/zsh/zellij-aliases.zsh` — sourced from `~/.zshrc`.
