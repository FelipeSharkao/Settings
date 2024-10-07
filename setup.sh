basedir="$(cd -- "$(dirname "$0")" > /dev/null && pwd -P)"

echo "$basedir" > "$HOME/.local/share/settings_path"

link() {
    rm "$2" 2> /dev/null
    ln -sf "$basedir/$1" "$2"
    echo "Created symlink $2 -> $1"
}

themezip() {
    mkdir -p "$HOME/.themes"
    wget -qO /tmp/theme.zip "$1"
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
link lazygit "$HOME/.config/lazygit"
link nvim "$HOME/.config/nvim"
link wezterm/wezterm.lua "$HOME/.wezterm.lua"
link wallust "$HOME/.config/wallust"
link hypr "$HOME/.config/hypr"
link wlogout "$HOME/.config/wlogout"
link nwg-panel "$HOME/.config/nwg-panel"

themezip https://files04.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2NjEzNjE4NjkiLCJ1IjpudWxsLCJsdCI6ImZpbGVwcmV2aWV3IiwicyI6IjZjMDVhYTNhNzliYjhhNmMyNmIyNzYwZWYwZWI3ZWRiMmIwZWVjMTZmOTNlOGJhNWMyN2YxMWJjN2E5Mjg2OGVlY2E2NDQ5YTM2YzZiNjc5M2ViYTMzMWRhYmM2NzEzMThmZGJhYjI2NzkxZTVkMTQ2YTdjODFmNWYwM2Y5NDJhIiwidCI6MTcyODE0NTE1OSwic3RmcCI6IiIsInN0aXAiOiIyODA0OjMzY2M6MTY1YTo5MzAwOmU4MTE6ZGFhYzpmNWNjOjQzODgifQ.-Q6fdfUL5Obpu6Zncf2n6zqfX97b2gsVqQcZNGEH2_k/Dark.zip
