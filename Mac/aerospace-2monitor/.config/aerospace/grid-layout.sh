#!/usr/bin/env bash

# Builds a Hyprland-like 2x2 grid as windows are added to a workspace:
#   1 window:  fills the workspace
#   2 windows: side by side (default AeroSpace behavior, no action needed)
#   3rd:       joins under window 2 (right column becomes a vertical stack)
#   4th:       joins under window 1 (left column becomes a vertical stack)
# A 5th+ overflow window moves to the closest workspace on the same monitor
# that has fewer than 4 windows, focus follows it there, and the same
# 3rd/4th join logic is re-applied in that workspace. If every workspace on
# the monitor is already full, the window is left as a plain new column.
#
# Runs on every on-window-detected callback (after restore-tiling.sh).

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

route_new_window() {
    "$script_dir/restore-tiling.sh"

    local count
    count=$(aerospace list-windows --workspace focused --count)

    if (( count == 3 )); then
        aerospace join-with left
    elif (( count == 4 )); then
        aerospace move left
        aerospace join-with left
    elif (( count >= 5 )); then
        overflow_to_sibling_workspace
    fi
}

overflow_to_sibling_workspace() {
    local current target ws ws_count
    current=$(aerospace list-workspaces --focused --format '%{workspace}')
    target=""

    while IFS= read -r ws; do
        [[ "$ws" == "$current" ]] && continue
        ws_count=$(aerospace list-windows --workspace "$ws" --count)
        if (( ws_count < 4 )); then
            target="$ws"
            break
        fi
    done < <(aerospace list-workspaces --monitor focused --format '%{workspace}')

    if [[ -z "$target" ]]; then
        return 0
    fi

    aerospace move-node-to-workspace --focus-follows-window "$target"
    route_new_window
}

route_new_window
