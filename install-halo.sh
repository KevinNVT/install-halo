#!/bin/bash
set -e

echo "🔧 Updating system and installing required packages..."
sudo pacman -Syu --noconfirm

# Install core tools
sudo pacman -S --noconfirm \
  hyprland waybar foot zsh thunar lf neovim firefox \
  pavucontrol mako rofi wofi i3lock-color \
  ttf-fira-code-nerd docker lazydocker btop \
  wl-clipboard cliphist unzip network-manager-applet \
  git wget unzip base-devel xdg-desktop-portal-hyprland \
  polkit-kde swww

echo "Setting zsh as default shell..."
chsh -s /bin/zsh

echo "Installing Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Downloading Tokyo Night theme for inspiration..."
mkdir -p ~/.themes
git clone https://github.com/folke/tokyonight.nvim.git ~/tokyo-theme

echo "Creating basic config directories..."
mkdir -p ~/.config/{hypr,waybar,wofi,foot,nvim,lf,mako,swww}

echo "Enabling necessary services..."
sudo systemctl enable --now docker
sudo systemctl enable --now NetworkManager

echo "Enabling virtualbox guest additions (if in VBox)..."
sudo pacman -S --noconfirm virtualbox-guest-utils
sudo systemctl enable --now vboxservice

echo "🛠️ Setting up Hyprland autostart from TTY..."
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec Hyprland' >> ~/.zprofile

echo "Done"
echo "You can now reboot, log in from TTY1, and Hyprland will start automatically."
