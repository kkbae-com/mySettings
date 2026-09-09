#!/usr/bin/env bash

# Runs on every on-window-detected callback. If the focused workspace now has
# more than one window, any floating window(s) left over from
# center-float.sh get put back into the tiling layout so the new window can
# split the space normally. No-op when the workspace still has only one
# window.

set -euo pipefail

window_count=$(aerospace list-windows --workspace focused --count)

if [[ "$window_count" -le 1 ]]; then
    exit 0
fi

while IFS=$'\t' read -r id layout; do
    if [[ "$layout" == "floating" ]]; then
        aerospace layout tiling --window-id "$id"
    fi
done < <(aerospace list-windows --workspace focused --format '%{window-id}%{tab}%{window-layout}')
