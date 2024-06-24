#!/bin/bash

# Function to add a new user
add_new_user() {
    read -p "Enter the new username: " username
    useradd -m -G wheel -s /bin/zsh "$username"
    passwd "$username"
}

# Update the system
pacman -Syu --noconfirm

# Install Desktop Environment
pacman -S --noconfirm budgie-desktop

# Install Compositor
pacman -S --noconfirm picom

# Install Terminal Emulator
pacman -S --noconfirm kitty

# Install Shell and oh-my-zsh
pacman -S --noconfirm zsh
sudo -u "$username" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Bar
pacman -S --noconfirm polybar

# Install Wallpaper Manager
pacman -S --noconfirm feh

# Install Fonts and Icon Themes
pacman -S --noconfirm ttf-nerd-fonts-symbols papirus-icon-theme
sudo -u "$username" git clone https://github.com/IdreesInc/Monocraft.git /home/"$username"/Monocraft
cp -r /home/"$username"/Monocraft/*.ttf /usr/share/fonts/
curl -LO https://www.monolisa.dev/download/Monolisa.ttf
cp Monolisa.ttf /usr/share/fonts/
pacman -S --noconfirm otf-cascadia-code ttf-bitstream-vera

# Install Extras
pacman -S --noconfirm dunst code neovim firefox pulseaudio rofi rustup go gcc nasm qemu

# Set up rust toolchain
sudo -u "$username" rustup default stable

# Create configuration directories for the new user
sudo -u "$username" mkdir -p /home/"$username"/.config/picom
sudo -u "$username" mkdir -p /home/"$username"/.config/polybar
sudo -u "$username" mkdir -p /home/"$username"/.config/kitty
sudo -u "$username" mkdir -p /home/"$username"/.config/rofi

# Picom configuration
cat <<EOF > /home/"$username"/.config/picom/picom.conf
shadow = true;
fading = true;
EOF

# Polybar configuration
cat <<EOF > /home/"$username"/.config/polybar/config
[bar/example]
width = 100%
height = 30
background = #222222
foreground = #aaaaaa
modules-left = i3
modules-center = 
modules-right = cpu memory date

[module/i3]
type = internal/i3
format = <label-state>

[module/cpu]
type = internal/cpu
interval = 2
format = <label>

[module/memory]
type = internal/memory
interval = 2
format = <label-used>/<label-total>

[module/date]
type = internal/date
interval = 60
date = %Y-%m-%d %H:%M:%S
label = %date%
EOF

# Kitty configuration
cat <<EOF > /home/"$username"/.config/kitty/kitty.conf
font_family Monocraft
font_size 12.0
EOF

# Set wallpaper
sudo -u "$username" feh --bg-scale ./5c5cb147-f329-439c-8a4a-9b30735614e2.jpg

# Enable pulseaudio
systemctl --user enable pulseaudio
systemctl --user start pulseaudio

# Rofi configuration
cat <<EOF > /home/"$username"/.config/rofi/config.rasi
configuration {
    modi: "drun,run";
    theme: "gruvbox-dark";
}
EOF

# Set zsh as default shell for the new user
chsh -s $(which zsh) "$username"

# Add the new user to the sudoers file
echo "$username ALL=(ALL) ALL" >> /etc/sudoers

# Create a new user
add_new_user
