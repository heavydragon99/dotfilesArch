# dotfilesArch

Git repository for managing dotfiles and configuration files for blank Arch Linux installations using Hyprland.

## Table of Contents
- [Introduction](#introduction)
- [First-Time Setup](#first-time-setup)
- [Setting Up the Dotfiles Alias](#setting-up-the-dotfiles-alias)
- [Adding Files to This Repository](#adding-files-to-this-repository)
- [Using on a New Blank Arch Installation](#using-on-a-new-blank-arch-installation)
- [Common Commands](#common-commands)
- [Best Practices](#best-practices)

## Introduction

This repository uses a bare Git repository method to manage dotfiles. This approach allows you to:
- Track configuration files in your home directory without moving them
- Keep your home directory clean (no nested Git repositories)
- Easily sync configurations across multiple blank Arch installations
- Maintain version control for all your dotfiles

## First-Time Setup

### 1. Initialize the Bare Repository

On your main system where you want to start tracking dotfiles:

```bash
# Initialize a bare Git repository in your home directory
git init --bare $HOME/.dotfiles

# Create the alias for managing dotfiles
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc

# If using zsh, add to .zshrc instead:
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc

# Reload your shell configuration
source $HOME/.bashrc  # or source $HOME/.zshrc for zsh
```

### 2. Configure the Repository

```bash
# Hide untracked files to keep status clean
dotfiles config --local status.showUntrackedFiles no

# Set your Git identity for this repository
dotfiles config user.name "Your Name"
dotfiles config user.email "your.email@example.com"

# Add the remote repository (replace with your actual repo URL)
dotfiles remote add origin https://github.com/heavydragon99/dotfilesArch.git
```

## Setting Up the Dotfiles Alias

The `dotfiles` alias is the key to managing your configuration files. It works exactly like the `git` command, but operates on your home directory.

### For Bash Users

Add this line to `~/.bashrc`:

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### For Zsh Users

Add this line to `~/.zshrc`:

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### For Fish Users

Add this line to `~/.config/fish/config.fish`:

```fish
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

After adding the alias, reload your shell configuration:
```bash
source ~/.bashrc  # or ~/.zshrc or ~/.config/fish/config.fish
```

## Adding Files to This Repository

Once the alias is set up, you can add any configuration file from your home directory:

### Adding Individual Files

```bash
# Add a specific configuration file
dotfiles add ~/.config/hypr/hyprland.conf

# Add multiple files at once
dotfiles add ~/.config/waybar/config ~/.config/waybar/style.css

# Check what's staged
dotfiles status

# Commit the changes
dotfiles commit -m "Add Hyprland and Waybar configurations"

# Push to GitHub
dotfiles push origin main
```

### Adding Entire Configuration Directories

```bash
# Add all files in a configuration directory
dotfiles add ~/.config/hypr/
dotfiles add ~/.config/kitty/
dotfiles add ~/.config/nvim/

# Commit and push
dotfiles commit -m "Add Hyprland, Kitty, and Neovim configurations"
dotfiles push origin main
```

### Common Files to Track

Here are some common dotfiles you might want to track:

```bash
# Shell configurations
dotfiles add ~/.bashrc ~/.bash_profile ~/.zshrc

# Hyprland configuration
dotfiles add ~/.config/hypr/

# Terminal emulator configurations
dotfiles add ~/.config/kitty/
dotfiles add ~/.config/alacritty/

# Status bars and panels
dotfiles add ~/.config/waybar/
dotfiles add ~/.config/polybar/

# Application launcher
dotfiles add ~/.config/rofi/
dotfiles add ~/.config/wofi/

# Text editors
dotfiles add ~/.vimrc
dotfiles add ~/.config/nvim/

# Git configuration
dotfiles add ~/.gitconfig

# Commit all changes
dotfiles commit -m "Add common configuration files"
dotfiles push origin main
```

## Using on a New Blank Arch Installation

When setting up a new blank Arch system, follow these steps to restore your dotfiles:

### 1. Install Prerequisites

```bash
# Update system
sudo pacman -Syu

# Install git if not already installed
sudo pacman -S git
```

### 2. Create the Dotfiles Alias

Before cloning, set up the alias temporarily:

```bash
# For current session
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Add to shell config permanently
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc
```

### 3. Clone the Repository

```bash
# Clone your dotfiles repository as a bare repository
git clone --bare https://github.com/heavydragon99/dotfilesArch.git $HOME/.dotfiles

# Configure the repository
dotfiles config --local status.showUntrackedFiles no
```

### 4. Checkout Your Dotfiles

```bash
# Attempt to checkout
dotfiles checkout

# If you get conflicts (existing files), you have two options:

# Option 1: Backup existing files and retry
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.dotfiles-backup/{}
dotfiles checkout

# Option 2: Force checkout (overwrites existing files)
dotfiles checkout -f
```

### 5. Verify Setup

```bash
# Check the status
dotfiles status

# List tracked files
dotfiles ls-tree -r main --name-only
```

Your dotfiles are now restored! All your configuration files should be in their proper locations.

## Common Commands

The `dotfiles` alias works like `git`, but for your home directory:

```bash
# Check status of tracked files
dotfiles status

# Add a file
dotfiles add ~/.config/somefile

# Commit changes
dotfiles commit -m "Update configuration"

# Push to remote
dotfiles push origin main

# Pull latest changes
dotfiles pull origin main

# View commit history
dotfiles log

# View differences
dotfiles diff

# List all tracked files
dotfiles ls-tree -r main --name-only

# Remove a file from tracking (but keep the file)
dotfiles rm --cached ~/.config/somefile
```

## Best Practices

### 1. Don't Track Everything

Avoid tracking files that contain:
- Sensitive information (passwords, API keys, tokens)
- Cache files
- Binary files or compiled programs
- Large files
- Machine-specific configurations that won't work on other systems

### 2. Use a .gitignore

Create a `.gitignore` file in your home directory to exclude sensitive or unnecessary files:

```bash
# Add .gitignore to your home directory
echo ".gitignore" >> ~/.gitignore
dotfiles add ~/.gitignore
dotfiles commit -m "Add .gitignore"
```

### 3. Document Your Setup

Keep track of:
- Packages you need to install (`pacman -S package-name`)
- AUR packages
- Dependencies for your configurations
- Custom scripts or tools

### 4. Regular Commits

Commit changes frequently with descriptive messages:

```bash
dotfiles commit -m "Update Hyprland keybindings for better workflow"
```

### 5. Test on Fresh Installations

Periodically test your dotfiles on a fresh installation (VM or spare machine) to ensure everything works correctly.

## Troubleshooting

### Alias Not Working

If the `dotfiles` command isn't found:
```bash
# Make sure you've reloaded your shell config
source ~/.bashrc  # or ~/.zshrc
```

### Conflicts During Checkout

If files already exist during checkout:
```bash
# Backup and retry
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.dotfiles-backup/{}
dotfiles checkout
```

### Can't See Untracked Files

This is intentional! To see untracked files temporarily:
```bash
dotfiles config --local status.showUntrackedFiles normal
```

---

**Note**: This setup is specifically configured for blank Arch Linux installations with Hyprland, but the method works for any Linux distribution.
