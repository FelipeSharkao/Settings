#!/bin/bash

if [[ -f ~/.config/aether/theme/light.mode ]]; then
    theme="--light"
else
    theme="--dark"
fi

delta "$theme"                                                     \
      --paging=never                                               \
      --line-numbers                                               \
      --hyperlinks                                                 \
      --hyperlinks-file-link-format="lazygit-edit://{path}:{line}" \
      "$@"
