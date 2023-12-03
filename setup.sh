BASEDIR="$(cd -- "$(dirname "$0")" > /dev/null && pwd -P)"

link() {
    echo "Linking $2 -> $1"
    rm "$2" 2> /dev/null
    ln -sf "$BASEDIR/$1" "$2"
}

link Zsh/zshrc "$HOME/.zshrc"
link Nvim "$HOME/.config/nvim"
link Kitty "$HOME/.config/kitty"
link Lazygit "$HOME/.config/lazygit"
