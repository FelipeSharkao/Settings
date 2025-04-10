basedir="$(cd -- "$(dirname "$0")" > /dev/null && pwd -P)"

echo "$basedir" > "$HOME/.local/share/settings_path"

link() {
    rm "$2" 2> /dev/null
    ln -sf "$basedir/$1" "$2"
    echo "Created symlink $2 -> $1"
}

themezip() {
    mkdir -p "$HOME/.themes"
    wget -O /tmp/theme.zip "$(wget -O - "$1/loadFiles" | jq -r ".files | map(select(.title = \"$2\")) | .[-1].url" | sed 's/%3A/:/g' | sed 's/%2F/\//g')"
    unzip -qud "$HOME/.themes" /tmp/theme.zip
    zipinfo -1 /tmp/theme.zip | grep '^[^/]*/$' | xargs -l echo 'Added theme'
}

link shell/zshrc "$HOME/.zshrc"
link shell/profile "$HOME/.profile"
link shell/profile "$HOME/.xprofile"
link shell/profile "$HOME/.bash_profile"
link shell/profile "$HOME/.zprofile"
link shell/profile "$HOME/.zlogin"
link shell/profile "$HOME/.zshenv"
link nvim "$HOME/.config/nvim"
link wezterm/wezterm.lua "$HOME/.wezterm.lua"
link wallust "$HOME/.config/wallust"
link hypr "$HOME/.config/hypr"
link wlogout "$HOME/.config/wlogout"
link nwg-panel "$HOME/.config/nwg-panel"
link yazi "$HOME/.config/yazi"
link .editorconfig "$HOME/.editorconfig"

themezip https://www.gnome-look.org/p/1876396 Dark.zip
