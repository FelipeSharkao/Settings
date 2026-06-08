#!/bin/bash

for pty in /dev/pts/[0-9]*; do
    bash ~/.config/aether/theme/shell-colors.sh > "$pty"
done
