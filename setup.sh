basedir="$(cd -- "$(dirname "$0")" > /dev/null && pwd -P)"

echo "$basedir" > "$HOME/.local/share/settings_path"

link() {
    rm "$2" 2> /dev/null
    ln -sf "$basedir/$1" "$2"
    echo "Created symlink $2 -> $1"
}

link shell/zshrc "$HOME/.zshrc"
link shell/profile "$HOME/.profile"
link shell/profile "$HOME/.xprofile"
link shell/profile "$HOME/.bash_profile"
link shell/profile "$HOME/.zprofile"
link shell/profile "$HOME/.zlogin"
link shell/profile "$HOME/.zshenv"
link lazygit "$HOME/.config/lazygit"
link nvim "$HOME/.config/nvim"
link wezterm/wezterm.lua "$HOME/.wezterm.lua"
link wallust "$HOME/.config/wallust"
link hypr "$HOME/.config/hypr"
link wlogout "$HOME/.config/wlogout"
link nwg-panel "$HOME/.config/nwg-panel"
