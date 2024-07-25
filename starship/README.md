# starship

> [!NOTE]
> Requires a Nerd Font

Install
```
brew install starship
```

Insert into `$ZSH_DOTFILES/.interactive.zsh` or `~/.zshrc`
```
#Default: ~/.config/starship.toml
export STARSHIP_CONFIG=$ZSH_DOTFILES/theme/starship/starship.toml

#Default: ~/.cache/starship/session_${STARSHIP_SESSION_KEY}.log, where the session key is corresponding to an instance of your termina
export STARSHIP_CACHE=$ZSH_DOTFILES/theme/starship/.cache
```

Insert into `$ZSH_DOTFILES/.env.zsh` or `~/.zshenv` and unset any other themes
```
eval "$(starship init zsh)"
```

> [!IMPORTANT]
> Select starship theme by symlinking
> ```
> ln -sfv theme/hyperspace.toml starship.toml
> ```
