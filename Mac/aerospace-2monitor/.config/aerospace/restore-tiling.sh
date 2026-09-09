#!/usr/bin/env bash

# Called by grid-layout.sh (for the workspace it's currently routing a
# window into). If that workspace now has more than one window, any
# floating window(s) left over from center-float.sh get put back into the
# tiling layout so the new window can split the space normally. No-op when
# the workspace still has only one window.
#
# Usage: restore-tiling.sh [workspace]   (defaults to the focused workspace)

set -euo pipefail

workspace="${1:-focused}"

window_count=$(aerospace list-windows --workspace "$workspace" --count)

if [[ "$window_count" -le 1 ]]; then
    exit 0
fi

while IFS=$'\t' read -r id layout; do
    if [[ "$layout" == "floating" ]]; then
        aerospace layout tiling --window-id "$id"
    fi
done < <(aerospace list-windows --workspace "$workspace" --format '%{window-id}%{tab}%{window-layout}')
