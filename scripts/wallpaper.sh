WALLPAPER=$(find "$1" -type f | shuf -n 1)

killall swaybg &> /dev/null
swaybg --image "$WALLPAPER" --mode fill &> /dev/null & disown

gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" 2> /dev/null
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER" 2> /dev/null

wallust run "$WALLPAPER"

killall nwg-panel &> /dev/null
nwg-panel &> /dev/null & disown

killall mako &> /dev/null
mako &> /dev/null & disown

pywalfox update &> /dev/null & disown
nvr --serverlist | xargs -I{} zsh -c 'nvr --nostart --servername "{}" +"colorscheme wal" || true' &> /dev/null & disown
