#!/bin/bash

kittyTo () {
    local socket="unix:@kitty-control-$1"
    shift
    kitty @ --to "$socket" "$@"
}

if [[ -f ~/.config/aether/theme/light.mode ]]; then
    opacity=0.9
else
    opacity=0.8
fi

sed -i "s/{opacity}/$opacity/g" ~/.config/aether/theme/kitty-colors.conf

for pid in $(pgrep kitty); do
    kittyTo "$pid" set-colors --all ~/.config/aether/theme/kitty-colors.conf
    kittyTo "$pid" set-background-opacity --all "$opacity"
done
