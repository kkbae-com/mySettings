# Git Configuration

**Tool:** Git - Version control system

## Files

- `.gitconfig` - Global Git configuration with user identity and settings
- `.config/git/ignore` - Global gitignore patterns applied to all repositories

## Features

- User identity (name and email)
- Global gitignore patterns
- Git aliases and settings

## Installation

1. Install Git (usually pre-installed on macOS):
   ```bash
   brew install git  # or use Xcode Command Line Tools
   ```

2. Deploy configuration:
   ```bash
   cd ~/Documents/Projects/kkbae/mySettings/Mac
   stow -t ~ git
   ```

3. Verify configuration:
   ```bash
   git config --global --list
   ```

## Configuration Details

### User Identity

Set in `.gitconfig`:
- Name: Karl Merecido
- Email: kmerecido@gmail.com

### Global Ignore Patterns

The `.config/git/ignore` file contains patterns that Git will ignore across all repositories, preventing common system and editor files from being tracked.

## Note

This is your **global** Git configuration, not project-specific settings. Project-specific configs remain in individual repository `.git/config` files.

## Dependencies

- Git (pre-installed or via Homebrew)
