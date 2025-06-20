#!/usr/bin/env bash
set -e

# Usage: ./install_neovim.sh [--stable]

NVIM_SRC="$HOME/dotfilesx/neovim"
NVIM_INSTALL="$HOME/dotfilesx/neovim-install"
NVIM_BIN="$NVIM_INSTALL/bin/nvim"
LOCAL_BIN="$HOME/bin"
XDG_CONFIG_HOME="$HOME/dotfilesx/kickstart-modular"

# Parse arguments
STABLE=0
for arg in "$@"; do
    if [[ "$arg" == "--stable" ]]; then
        STABLE=1
    fi
done

OS="$(uname -s)"

if [[ "$OS" == "Linux" ]] && grep -qi ubuntu /etc/os-release 2>/dev/null; then
    # Ubuntu logic
    echo "Detected Ubuntu Linux."
    echo "Installing Neovim build dependencies..."
    sudo apt-get update
    sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential git
elif [[ "$OS" == "Darwin" ]]; then
    # macOS logic
    echo "Detected macOS."
    echo "Installing Xcode Command Line Tools (if needed)..."
    xcode-select --install 2>/dev/null || true
    echo "Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
    echo "Installing Neovim build dependencies with Homebrew..."
    brew install ninja cmake gettext curl
else
    echo "This script is intended for Ubuntu Linux or macOS only. Exiting."
    exit 1
fi

# Clone or update Neovim repo (always to $HOME/dotfilesx/neovim)
if [ ! -d "$NVIM_SRC" ]; then
    echo "Cloning Neovim repo to $NVIM_SRC..."
    git clone --depth 1 https://github.com/neovim/neovim.git "$NVIM_SRC"
else
    echo "Updating Neovim repo in $NVIM_SRC..."
    cd "$NVIM_SRC"
    git pull origin master
fi

cd "$NVIM_SRC"
if [[ $STABLE -eq 1 ]]; then
    echo "Checking out stable branch..."
    git checkout stable
fi

# Build Neovim
echo "Building Neovim..."
make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install Neovim to custom prefix (always $HOME/dotfilesx/neovim-install)
mkdir -p "$NVIM_INSTALL"
echo "Installing Neovim to $NVIM_INSTALL..."
make install CMAKE_INSTALL_PREFIX="$NVIM_INSTALL"

# Symlink to ~/bin/nvim
mkdir -p "$LOCAL_BIN"
ln -sf "$NVIM_BIN" "$LOCAL_BIN/nvim"
echo "Symlinked $NVIM_BIN to $LOCAL_BIN/nvim"

# Ensure $HOME/bin is in PATH for this session
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    export PATH="$HOME/bin:$PATH"
    echo "Added $HOME/bin to PATH for this session."
fi

echo "Neovim build and install complete. You can now run 'nvim' from anywhere."
echo "Your Neovim config directory (XDG_CONFIG_HOME) should be: $XDG_CONFIG_HOME" 