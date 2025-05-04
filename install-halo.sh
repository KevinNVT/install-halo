#!/bin/bash

set -e

echo "🔧 Updating system and installing required packages..."

# Install yay (AUR helper) if not installed
if ! command -v yay &> /dev/null; then
  echo "Installing yay (AUR helper)..."
  cd ~
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
fi

# Update system and install official packages
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm \
  neovim git base-devel \
  foot thunar zsh waybar firefox \
  wl-clipboard grim slurp wf-recorder \
  hyprland rofi unzip wget curl \
  networkmanager openssh

# Install AUR packages
yay -S --noconfirm \
  i3lock-color ttf-fira-code-nerd lazydocker polkit-kde-agent

# Enable essential services
echo "Enabling NetworkManager and SSH..."
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo systemctl enable sshd
sudo systemctl start sshd

# Set zsh as default shell
echo "Setting zsh as default shell for $(whoami)..."
chsh -s /bin/zsh

# Create basic Hyprland config
echo "Setting up Hyprland configuration..."

mkdir -p ~/.config/hypr
cat <<EOF > ~/.config/hypr/hyprland.conf
exec-once = waybar &
exec-once = firefox &
exec-once = foot &
EOF

# Create .zshrc with Nerd Font prompt support
echo "Creating basic .zshrc..."
cat <<EOF > ~/.zshrc
export TERMINAL=foot
export EDITOR=nvim
alias ll='ls -lah --color=auto'
EOF

# Set up TTY autologin and Hyprland autostart (on TTY1)
echo "Setting up TTY autologin and Hyprland autostart..."
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF

mkdir -p ~/.bash_profile
echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && Hyprland' >> ~/.bash_profile

echo "Installation complete! Reboot your system to launch into Hyprland."
