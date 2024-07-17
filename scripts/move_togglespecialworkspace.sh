if [ -z "$1" ]; then
    echo "Usage: move_togglespecialworkspace.sh <special workspace>"
    exit 1
fi

workspace="special:$1"

# Check if the current window is on the special workspace
if hyprctl activewindow | grep -q "($workspace)"; then
    # Move the current window to the normal workspace
    hyprctl dispatch movetoworkspace e+0
else
    # Move the current window to the special workspace
    hyprctl dispatch movetoworkspace $workspace
fi
