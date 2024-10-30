WALLPAPER=$(find "$1" -type f | shuf -n 1)

echo "Setting swaybg..."
killall swaybg &> /dev/null
swaybg --image "$WALLPAPER" --mode fill &> /dev/null & disown

echo "Setting gnome background..."
gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER" 2> /dev/null
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER" 2> /dev/null

echo "Running wallust..."
wallust run "$WALLPAPER"

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
