## Personal Configurations

Some configurations I want to keep around different devices.

### Setup

Clone the repo:

```sh
git clone <repo-url> ~/Code/dotfiles
```

Copy what you need:

```sh
# Zsh modules (aliases, functions, completions)
mkdir -p ~/.config/zsh
cp ~/Code/dotfiles/.config/zsh/*.zsh ~/.config/zsh/

# Zellij config + layouts
mkdir -p ~/.config/zellij
cp -r ~/Code/dotfiles/.config/zellij/ ~/.config/zellij/

# Neovim
mkdir -p ~/.config/nvim
cp -r ~/Code/dotfiles/.config/nvim/ ~/.config/nvim/

# GitHub CLI
mkdir -p ~/.config/gh
cp ~/Code/dotfiles/.config/gh/config.yml ~/.config/gh/

# Ghostty
mkdir -p ~/.config/ghostty
cp -r ~/Code/dotfiles/ghostty/ ~/.config/ghostty/

# Git
cp ~/Code/dotfiles/.gitconfig ~/.gitconfig
```

Then add these to your `~/.zshrc`:

```sh
[ -s ~/.config/zsh/git-aliases.zsh ] && source ~/.config/zsh/git-aliases.zsh
[ -s ~/.config/zsh/worktree-aliases.zsh ] && source ~/.config/zsh/worktree-aliases.zsh
[ -s ~/.config/zsh/docker-aliases.zsh ] && source ~/.config/zsh/docker-aliases.zsh
[ -s ~/.config/zsh/zellij-aliases.zsh ] && source ~/.config/zsh/zellij-aliases.zsh
[ -s ~/.config/zsh/ft.zsh ] && source ~/.config/zsh/ft.zsh
```

### Structure

```
.config/
  gh/            GitHub CLI config
  nvim/          Neovim config
  tasks/         Task runner configs
  zellij/        Zellij config + layouts
  zsh/           Zsh alias modules (see .config/zsh/README.md)
ghostty/         Ghostty terminal config
.gitconfig       Git config
```
