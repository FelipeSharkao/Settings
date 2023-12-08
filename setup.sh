BASEDIR="$(cd -- "$(dirname "$0")" > /dev/null && pwd -P)"

link() {
    echo "Linking $2 -> $1"
    rm "$2" 2> /dev/null
    ln -sf "$BASEDIR/$1" "$2"
}

link Kitty "$HOME/.config/kitty"
link Lazygit "$HOME/.config/lazygit"
link Nvim "$HOME/.config/nvim"
link WezTerm/wezterm.lua "$HOME/.wezterm.lua"
link Zsh/zshrc "$HOME/.zshrc"
