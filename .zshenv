source_if_exists () {
    [[ -f "$1" ]] && source "$1"
}

alias tmx="tmux -f ~/.tmux_outer.conf new -As0"
alias weather='curl wttr.in/boeblingen'

export PATH=~/.local/bin:$PATH
export EDITOR=nvim

fixssh() {
    vars=$(tmux show-env |sed -n 's/^\(SSH_[^=]*\|DISPLAY\)=\(.*\)/export \1="\2"/p')
    echo $vars
    eval $vars
}

source_if_exists "$HOME/.cargo/env"
source_if_exists "$HOME/.zshenv_local"
