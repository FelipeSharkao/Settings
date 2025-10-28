case "$1" in
light)
    PALETTE="light16"
    GTK_THEME="MarshmallowLight"
    GTK_COLOR_SCHEME="prefer-light"
    ;;
dark)
    PALETTE="dark16"
    THEME="MarshmallowDark"
    GTK_COLOR_SCHEME="prefer-dark"
    ;;
*)
    echo "Usage: $0 {light|dark} [folder]"
    exit 1
    ;;
esac

if [ -z "$2" ]; then
    WALLPAPER="$(cat ~/.cache/wal/wal)"
else
    WALLPAPER="$(find "$2" -type f | shuf -n 1)"
fi

echo "Setting swaybg..."
killall swaybg &> /dev/null
swaybg --image "$WALLPAPER" --mode fill &> /dev/null & disown

echo "Setting gnome background..."
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" 2> /dev/null
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER" 2> /dev/null

echo "Setting GTK theme..."
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface color-scheme "$GTK_COLOR_SCHEME"

echo "Running wallust..."
wallust run -p "$PALETTE" "$WALLPAPER"

echo "Updating kitty..."
kitten @ set-colors --all "~/.cache/wal/colors-kitty.conf" &> /dev/null

echo "Resetting nwg-panel..."
killall nwg-panel &> /dev/null
nwg-panel &> /dev/null & disown

echo "Resetting mako..."
killall mako &> /dev/null
mako &> /dev/null & disown

echo "Uptating pywalfox..."
pywalfox update 2> /dev/null & disown

echo "Notifying neovim..."
nvr --serverlist | xargs -I{} zsh -c 'nvr --nostart --servername "{}" +"colorscheme wal" || true' &> /dev/null & disown
