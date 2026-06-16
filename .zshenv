source_if_exists () {
    [[ -f "$1" ]] && source "$1"
}

export PATH=~/.local/bin:$PATH
export EDITOR=nvim

source_if_exists "$HOME/.zshenv_local"
source_if_exists "$HOME/.cargo/env"
