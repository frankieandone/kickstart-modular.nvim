export DOTFILES="${DOTFILES:-${HOME}/dotfilesx}"
export ZSH_DOTFILES="${ZSH_DOTFILES:-${DOTFILES}/zsh}"
echo "DOTFILES: $DOTFILES"
echo "ZSH_DOTFILES: $ZSH_DOTFILES"

# Platform detection
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MACOS=true
    if [[ $(uname -m) == "arm64" ]]; then
        IS_M1=true
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    IS_LINUX=true
fi

# Create ZSH config directory if it doesn't exist
mkdir -p "$HOME/.config/zsh"

# Create symlinks for ZSH configuration
if [[ -f "$ZSH_DOTFILES/zshrc" ]]; then
    ln -sfv "$ZSH_DOTFILES/zshrc" "$HOME/.zshrc"
    ln -sfv "$ZSH_DOTFILES/zshrc" "$HOME/.config/zsh/.zshrc"
fi

if [[ -f "$ZSH_DOTFILES/zshenv" ]]; then
    ln -sfv "$ZSH_DOTFILES/zshenv" "$HOME/.zshenv"
    ln -sfv "$ZSH_DOTFILES/zshenv" "$HOME/.config/zsh/.zshenv"
fi

# Create other symlinks
ln -sfv "$DOTFILES/sh/shrc" "$HOME/.shrc"
ln -sfv "$DOTFILES/bash/bashrc" "$HOME/.bashrc"

# Setup tmux configuration and plugins
mkdir -p "$HOME/.config/tmux"
mkdir -p "$HOME/.tmux/plugins"

# Install tmux plugin manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Symlink tmux configuration
if [[ -f "$DOTFILES/tmux/tmux.conf" ]]; then
    ln -sfv "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
    ln -sfv "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
fi

if [ ! -d "$DOTFILES/kickstart" ]; then
    git clone git@github.com/frankieandone/kickstart.nvim.git
fi
ln -sfv "$DOTFILES/kickstart" "$DOTFILES/nvim"
ln -sfv "$DOTFILES/ideavim/ideavimrc" "$HOME/.ideavimrc"

# Package installation based on platform
if [[ "$IS_MACOS" == true ]]; then
    # macOS specific setup
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Add Homebrew to PATH for M1 Macs
    if [[ "$IS_M1" == true ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
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
        starship \
        tmux \
        reattach-to-user-namespace # Required for clipboard support in tmux
    brew doctor
    brew autoclean
elif [[ "$IS_LINUX" == true ]]; then
    # Ubuntu specific setup
    sudo apt update
    sudo apt install -y \
        zsh \
        fzf \
        ripgrep \
        bat \
        jq \
        httpie \
        neovim \
        certbot \
        nginx \
        curl \
        git \
        build-essential \
        pkg-config \
        libssl-dev \
        tmux \
        xclip # Required for clipboard support in tmux

    # Setup Cursor AppImage
    mkdir -p "$HOME/Applications"
    if [ ! -f "$HOME/Applications/Cursor.AppImage" ]; then
        echo "Downloading Cursor AppImage..."
        curl -L "https://download.cursor.sh/linux/appimage/x64" -o "$HOME/Applications/Cursor.AppImage"
        chmod +x "$HOME/Applications/Cursor.AppImage"
    fi

    # Install Cursor desktop file
    if [ -f "$DOTFILES/cursor/Cursor.desktop" ]; then
        mkdir -p "$HOME/.local/share/applications"
        cp "$DOTFILES/cursor/Cursor.desktop" "$HOME/.local/share/applications/"
        # Update icon path in desktop file
        sed -i "s|Icon=cursor|Icon=$HOME/Applications/Cursor.AppImage|" "$HOME/.local/share/applications/Cursor.desktop"
        # Update desktop database
        update-desktop-database "$HOME/.local/share/applications"
    fi
fi

# Install Node.js and pnpm using Volta (cross-platform)
if ! command -v volta &> /dev/null; then
    curl https://get.volta.sh | bash
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"
fi

volta install node@latest && volta install pnpm@latest

# Install Rust
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Create Alacritty config directory and symlink platform-specific config
mkdir -p "$HOME/.config/alacritty"

if [[ "$IS_MACOS" == true ]]; then
    # macOS specific Alacritty config
    ln -sfv "$DOTFILES/alacritty/alacritty-macos.toml" "$HOME/.config/alacritty/alacritty.toml"
    # Install JetBrainsMono Nerd Font if not present
    if ! brew list --cask | grep -q "font-jetbrains-mono-nerd-font"; then
        brew tap homebrew/cask-fonts
        brew install --cask font-jetbrains-mono-nerd-font
    fi
elif [[ "$IS_LINUX" == true ]]; then
    # Linux specific Alacritty config
    ln -sfv "$DOTFILES/alacritty/alacritty-linux.toml" "$HOME/.config/alacritty/alacritty.toml"
    # Install FiraCode Nerd Font if not present
    if ! fc-list | grep -q "FiraCode Nerd Font"; then
        mkdir -p ~/.local/share/fonts
        cd ~/.local/share/fonts
        curl -fLo "Fira Code Regular Nerd Font Complete.ttf" \
            "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf"
        fc-cache -f -v
        cd -
    fi
fi

# Install tmux plugins
if command -v tmux &> /dev/null; then
    # Start a server but don't attach to it
    tmux start-server
    # Create a new session but don't attach to it either
    tmux new-session -d
    # Install the plugins
    "$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"
    # Kill the server
    tmux kill-server
fi

