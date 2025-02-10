# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Default programs
export EDITOR="nvim"
export VISUAL="nvim"

# Configs
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export HISTFILE="$ZDOTDIR/.zhistory"	# History filepath
export HISTSIZE=10000			# Maximum events for internal history
export SAVEHIST=10000			# Maximum events in history file

# Assigning a key binding to the visual vim mode
export VI_MODE_ESC_INSERT="jk"

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"

# bat theme
export BAT_THEME="Dracula"

# fzf preview
export FZF_COMPLETION_OPTS="--border --info=inline"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --info=inline --bind 'ctrl-/:change-preview-window(hidden|)'"
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
