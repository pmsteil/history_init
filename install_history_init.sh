#!/bin/bash

# Gist URL for the raw version of your history_init.sh script
GITHUB_RAW_URL="https://raw.githubusercontent.com/pmsteil/history_init/master/history_init.sh"

# Download the latest version of the history_init.sh from the repo
curl -o ~/.history_init.sh "$GITHUB_RAW_URL"

# Check if .bashrc or .zshrc exists and append sourcing of the script
if [ -f ~/.bashrc ]; then
    if ! grep -q "source ~/.history_init.sh" ~/.bashrc; then
        echo "source ~/.history_init.sh" >> ~/.bashrc
        echo "Added history_init.sh to ~/.bashrc"
    fi
fi

if [ -f ~/.zshrc ]; then
    if ! grep -q "source ~/.history_init.sh" ~/.zshrc; then
        echo "source ~/.history_init.sh" >> ~/.zshrc
        echo "Added history_init.sh to ~/.zshrc"
    fi
fi

# Reload the shell configuration to apply changes
if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
fi

echo "History tracking script installed successfully!"
