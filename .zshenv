source_if_exists () {
    [[ -f "$1" ]] && source "$1"
}

source_if_exists "$HOME/.zshenv_local"
source_if_exists "$HOME/.cargo/env"

chaf () {
	if [[ $TERM == tmux* ]]; then
		chafa --format kitty --passthrough=tmux $@
	else
		chafa --format kitty $@
	fi
}

export PATH=~/.local/bin:$PATH
export EDITOR=nvim
