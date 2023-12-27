WALLPAPER=$(find "$1" -type f | shuf -n 1)

swww img "$WALLPAPER" --transition-step 40 2> /dev/null
gsettings get org.gnome.desktop.background picture-uri "file:/$WALLPAPER" 2> /dev/null

wal --saturate 0.5 -i "$WALLPAPER"

killall waybar &> /dev/null
waybar &> /dev/null & disown

pywalfox update
walogram -B
nvr --serverlist | xargs -I{} nvr --servername "{}" +"colorscheme wal"
