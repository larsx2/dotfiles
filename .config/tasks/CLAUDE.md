# Tasks Configuration

Taskfile configurations and helper scripts for `task` command.

## Structure

```
~/.config/tasks/
├── 1Password.yml          # 1Password CLI wrapper (1p:* namespace)
├── scripts/
│   └── 1p-search          # fzf-based search for 1Password items
└── CLAUDE.md
```

## Conventions

- Task namespaces use single colon: `1p:search`
- Subtasks use hyphens, not double colons: `1p:item-get` not `1p:item:get`
- Complex logic goes in `scripts/` directory, tasks call scripts
- fzf usage: inline with `--height=~50% --layout=reverse --exact`

## Adding New Taskfiles

Include in `~/Taskfile.yml`:

```yaml
includes:
  1p:
    taskfile: ~/.config/tasks/1Password.yml
  new-namespace:
    taskfile: ~/.config/tasks/NewTool.yml
```

## Scripts

Scripts should be executable and placed in `scripts/` directory. Use CLI args for parameters rather than embedding logic in Taskfile.yml.
