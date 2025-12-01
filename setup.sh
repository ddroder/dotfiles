#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}Starting dotfiles setup...${NC}"
echo "Dotfiles directory: $DOTFILES_DIR"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            echo "debian"
        elif [ -f /etc/fedora-release ]; then
            echo "fedora"
        elif [ -f /etc/arch-release ]; then
            echo "arch"
        else
            echo "linux"
        fi
    else
        echo "unknown"
    fi
}

OS=$(detect_os)
echo -e "${YELLOW}Detected OS: $OS${NC}"

# Install packages based on OS
install_packages() {
    echo -e "${GREEN}Installing zsh, tmux, neovim, and utilities...${NC}"

    case $OS in
        macos)
            if ! command -v brew &> /dev/null; then
                echo -e "${RED}Homebrew not found. Please install Homebrew first:${NC}"
                echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
                exit 1
            fi
            brew install zsh tmux neovim zoxide neofetch node
            # Install colorls via ruby gem
            if command -v gem &> /dev/null; then
                gem install colorls || echo -e "${YELLOW}Could not install colorls via gem${NC}"
            fi
            ;;
        debian)
            sudo apt update
            sudo apt install -y zsh tmux neovim zoxide neofetch ruby
            sudo gem install colorls || echo -e "${YELLOW}Could not install colorls${NC}"
            ;;
        fedora)
            sudo dnf install -y zsh tmux neovim zoxide neofetch ruby
            sudo gem install colorls || echo -e "${YELLOW}Could not install colorls${NC}"
            ;;
        arch)
            sudo pacman -S --noconfirm zsh tmux neovim zoxide neofetch ruby
            gem install colorls || echo -e "${YELLOW}Could not install colorls${NC}"
            ;;
        *)
            echo -e "${RED}Unknown OS. Please install packages manually.${NC}"
            exit 1
            ;;
    esac

    echo -e "${GREEN}Packages installed successfully!${NC}"
}

#Install node
install_node(){
brew install node
}

# Install Oh My Zsh
install_oh_my_zsh() {
    echo -e "${GREEN}Installing Oh My Zsh...${NC}"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh already installed, skipping..."
    else
        # Install Oh My Zsh without changing shell automatically
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    echo -e "${GREEN}Oh My Zsh installed successfully!${NC}"
}

# Install Powerlevel10k theme
install_p10k() {
    echo -e "${GREEN}Installing Powerlevel10k theme...${NC}"

    P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ -d "$P10K_DIR" ]; then
        echo "Powerlevel10k already installed, updating..."
        cd "$P10K_DIR" && git pull
    else
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    fi

    echo -e "${GREEN}Powerlevel10k installed successfully!${NC}"
}

# Install zsh plugins
install_zsh_plugins() {
    echo -e "${GREEN}Installing zsh plugins...${NC}"

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "zsh-autosuggestions already installed, updating..."
        cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && git pull
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo "zsh-syntax-highlighting already installed, updating..."
        cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && git pull
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    echo -e "${GREEN}Zsh plugins installed successfully!${NC}"
}

# Install tmux plugin manager (tpm)
install_tpm() {
    echo -e "${GREEN}Installing tmux plugin manager (tpm)...${NC}"

    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [ -d "$TPM_DIR" ]; then
        echo "tpm already installed, updating..."
        cd "$TPM_DIR" && git pull
    else
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi

    echo -e "${GREEN}tpm installed successfully!${NC}"
}

# Create symlinks for configurations
create_symlinks() {
    echo -e "${GREEN}Creating configuration symlinks...${NC}"

    # Backup existing configs if they exist
    backup_if_exists() {
        if [ -e "$1" ] && [ ! -L "$1" ]; then
            echo -e "${YELLOW}Backing up existing $1 to $1.backup${NC}"
            mv "$1" "$1.backup"
        elif [ -L "$1" ]; then
            rm "$1"
        fi
    }

    # Zsh config
    backup_if_exists "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
    echo "Linked zshrc"

    # Powerlevel10k config
    backup_if_exists "$HOME/.p10k.zsh"
    ln -sf "$DOTFILES_DIR/zsh/p10k.zsh" "$HOME/.p10k.zsh"
    echo "Linked p10k config"

    # Wezterm config
    backup_if_exists "$HOME/.wezterm.lua"
    ln -sf "$DOTFILES_DIR/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
    echo "Linked wezterm config"

    # Tmux config
    backup_if_exists "$HOME/.tmux.conf"
    ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    echo "Linked tmux config"

    # Neovim config
    mkdir -p "$HOME/.config"
    backup_if_exists "$HOME/.config/nvim"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    echo "Linked neovim config"

    # Neofetch config
    mkdir -p "$HOME/.config/neofetch"
    backup_if_exists "$HOME/.config/neofetch"
    ln -sf "$DOTFILES_DIR/neofetch" "$HOME/.config/neofetch"
    echo "Linked neofetch config"

    echo -e "${GREEN}Symlinks created successfully!${NC}"
}

# Copy background assets
copy_assets() {
    echo -e "${GREEN}Copying background assets...${NC}"

    mkdir -p "$HOME/backgrounds"
    cp -r "$DOTFILES_DIR/assets/backgrounds/"* "$HOME/backgrounds/" 2>/dev/null || true

    echo -e "${GREEN}Assets copied successfully!${NC}"
}

# Install vim-plug plugins
install_vim_plugins() {
    echo -e "${GREEN}Installing neovim plugins...${NC}"

    nvim --headless +PlugInstall +qall 2>/dev/null || echo -e "${YELLOW}Note: Run :PlugInstall manually in neovim if plugins weren't installed${NC}"

    echo -e "${GREEN}Neovim plugins installation initiated!${NC}"
}

# Install tmux plugins
install_tmux_plugins() {
    echo -e "${GREEN}Installing tmux plugins...${NC}"

    # Install plugins via tpm
    if [ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
        "$HOME/.tmux/plugins/tpm/bin/install_plugins"
    else
        echo -e "${YELLOW}Note: Start tmux and press prefix + I to install plugins${NC}"
    fi

    echo -e "${GREEN}Tmux plugins installation initiated!${NC}"
}

# Set zsh as default shell
set_default_shell() {
    echo -e "${GREEN}Setting zsh as default shell...${NC}"

    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)" || echo -e "${YELLOW}Could not change default shell. Run: chsh -s \$(which zsh)${NC}"
    else
        echo "zsh is already the default shell"
    fi
}

# Main execution
main() {
    echo ""
    echo "=========================================="
    echo "       Dotfiles Setup Script"
    echo "=========================================="
    echo ""

    install_packages
    install_oh_my_zsh
    install_p10k
    install_zsh_plugins
    install_tpm
    create_symlinks
    copy_assets
    install_vim_plugins
    install_tmux_plugins
    set_default_shell

    echo ""
    echo "=========================================="
    echo -e "${GREEN}Setup complete!${NC}"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal or run: source ~/.zshrc"
    echo "2. Open tmux and press 'Ctrl-a + I' to install tmux plugins"
    echo "3. Open neovim and run :PlugInstall if plugins weren't auto-installed"
    echo "4. Install a Nerd Font (MesloLGSDZ Nerd Font Propo) for icons to display correctly"
    echo "5. Run 'p10k configure' if you want to reconfigure the Powerlevel10k prompt"
    echo ""
}

main "$@"
