## Personal Configurations

Some configurations I want to keep around different devices.

### Setup

Clone the repo:

```sh
git clone https://github.com/larsx2/dotfiles.git "$HOME/.dotfiles"
```

Copy what you need:

```sh
# Zsh modules (aliases, functions, completions)
mkdir -p ~/.config/zsh
cp "$HOME/.dotfiles/.config/zsh/"*.zsh ~/.config/zsh/

# Zellij config + layouts
mkdir -p ~/.config/zellij
cp -r "$HOME/.dotfiles/.config/zellij/." ~/.config/zellij/

# Neovim
mkdir -p ~/.config/nvim
cp -r "$HOME/.dotfiles/.config/nvim/." ~/.config/nvim/

# GitHub CLI
mkdir -p ~/.config/gh
cp "$HOME/.dotfiles/.config/gh/config.yml" ~/.config/gh/

# Herdr
mkdir -p ~/.config/herdr
cp "$HOME/.dotfiles/.config/herdr/config.toml" ~/.config/herdr/

# Pi (credentials are intentionally excluded; run /login on each machine)
mkdir -p ~/.pi/agent
cp -R "$HOME/.dotfiles/.pi/agent/." ~/.pi/agent/

# Ghostty
mkdir -p ~/.config/ghostty
cp -r "$HOME/.dotfiles/ghostty/." ~/.config/ghostty/

# Git
cp "$HOME/.dotfiles/.gitconfig" ~/.gitconfig
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
  herdr/         Herdr config and keybindings
  nvim/          Neovim config
  tasks/         Task runner configs
  zellij/        Zellij config + layouts
  zsh/           Zsh alias modules (see .config/zsh/README.md)
.pi/agent/       Pi settings, models, keybindings, and theme
ghostty/         Ghostty terminal config
.gitconfig       Git config
```
