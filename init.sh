export DOTFILES="${DOTFILES:-${HOME}/dotfilesx}"
export ZSH_DOTFILES="${ZSH_DOTFILES:-${DOTFILES}/zsh}"
echo "DOTFILES: $DOTFILES"
echo "ZSH_DOTFILES: $ZSH_DOTFILES"

ln -sfv "$DOTFILES/sh/shrc" "$HOME/.shrc"
ln -sfv "$DOTFILES/bash/bashrc" "$HOME/.bashrc"
ln -sfv "$ZSH_DOTFILES/zshrc" "$HOME/.zshrc"
ln -sfv "$ZSH_DOTFILES/zshenv" "$HOME/.zshenv"

if [ ! -d "$DOTFILES/kickstart" ]; then
    git clone git@github.com/frankieandone/kickstart.nvim.git
fi
ln -sfv "$DOTFILES/kickstart" "$DOTFILES/nvim"
ln -sfv "$DOTFILES/ideavim/ideavimrc" "$HOME/.ideavimrc"

brew update
brew reinstall zinit \
    fzf \
    zoxide \
    ripgrep \
    bat \
    jq \
    httpie \
    neovim \
    certbot \
    nginx \
    volta \
    rustup \
    starship
brew doctor

volta install node@latest && volta install pnpm@latest

rustup-init -y
