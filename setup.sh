basedir="$(cd -- "$(dirname "$0")" > /dev/null && pwd -P)"

echo "$basedir" > "$HOME/.local/share/settings_path"

link() {
    rm "$2" 2> /dev/null
    ln -sf "$basedir/$1" "$2"
    echo "Created symlink $2 -> $1"
}

link Kitty "$HOME/.config/kitty"
link Lazygit "$HOME/.config/lazygit"
link Nvim "$HOME/.config/nvim"
link WezTerm/wezterm.lua "$HOME/.wezterm.lua"
link Zsh/zshrc "$HOME/.zshrc"
link Hypr "$HOME/.config/hypr"
