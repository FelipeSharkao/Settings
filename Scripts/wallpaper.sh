WALLPAPER=$(find "$1" -type f | shuf -n 1)

swww img "$WALLPAPER" --transition-step 40 2> /dev/null
gsettings get org.gnome.desktop.background picture-uri "file:/$WALLPAPER" 2> /dev/null

wal --saturate 0.5 -i "$WALLPAPER"

killall waybar &> /dev/null
waybar &> /dev/null & disown

pywalfox update
walogram -B
nvr --serverlist | xargs -I{} nvr --servername "{}" +"colorscheme wal"

# Set mako config
mkdir -p "$HOME/.config/mako" 2> /dev/null
rm "$HOME/.config/mako/config" 2> /dev/null
cp "$HOME/.cache/wal/colors-mako" "$HOME/.config/mako/config"
killall mako &> /dev/null
if mako &> /dev/null & disown; then
    echo "[I] reload: mako"
else
    echo "[E] Failed to reload mako"
fi
