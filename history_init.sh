# Function to initialize history logging for a project
history_init() {
    # Set the history file to be specific to the current directory
    export HISTFILE="$(pwd)/.project_history"

    # If the .project_history file doesn't exist, create it
    if [ ! -f "$HISTFILE" ]; then
        touch "$HISTFILE"
        echo ".project_history file created in: $PWD"
    fi

    # Common settings for both bash and zsh
    HISTSIZE=10000  # Optional: adjust the size of the history
    HISTFILESIZE=10000

    # Configure shell-specific history behavior
    if [ -n "$BASH_VERSION" ]; then
        # Bash-specific settings
        shopt -s histappend
        PROMPT_COMMAND='history -a; history -c; history -r'
        export HISTTIMEFORMAT='%F %T '  # Adds timestamp (YYYY-MM-DD HH:MM:SS) to each entry
        echo "$PWD history tracking enabled (bash)"
    elif [ -n "$ZSH_VERSION" ]; then
        # Zsh-specific settings
        setopt INC_APPEND_HISTORY  # Append history immediately after each command
        setopt SHARE_HISTORY       # Share history across multiple sessions
        setopt EXTENDED_HISTORY    # Add timestamps to the history file
        echo "$PWD history tracking enabled (zsh)"
    fi
}

# Automatically trigger history logging when cd'ing into a folder with .project_history
auto_history_init() {
    if [ -f "$(pwd)/.project_history" ]; then
        history_init
    else
        # If there's no .project_history file, reset to default history settings
        unset HISTFILE
        if [ -n "$BASH_VERSION" ]; then
            PROMPT_COMMAND='history -a'  # Default behavior for bash
            unset HISTTIMEFORMAT  # Disable timestamp formatting in default mode
        elif [ -n "$ZSH_VERSION" ]; then
            unsetopt INC_APPEND_HISTORY
            unsetopt EXTENDED_HISTORY
        fi
        echo "Using default shell history"
    fi
}

# Hook for directory change in bash
if [ -n "$BASH_VERSION" ]; then
    cd() {
        builtin cd "$@" || return
        auto_history_init
    }
fi

# Hook for directory change in zsh
if [ -n "$ZSH_VERSION" ]; then
    autoload -U add-zsh-hook
    add-zsh-hook chpwd auto_history_init
fi
