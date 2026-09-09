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
# Usage: grid-layout.sh [workspace] [window-id]
#   workspace  defaults to "focused" (the on-window-detected case, where the
#              new window's workspace is whatever's currently focused)
#   window-id  when given, join-with/move/move-node-to-workspace target this
#              window explicitly instead of relying on it being focused
#              (needed when called after a manual move-node-to-workspace,
#              since focus doesn't necessarily follow the moved window)

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

route_new_window() {
    local workspace="${1:-focused}"
    local window_id="${2:-}"

    if [[ "$workspace" == "focused" ]]; then
        workspace=$(aerospace list-workspaces --focused --format '%{workspace}')
    fi

    "$script_dir/restore-tiling.sh" "$workspace"

    local count
    count=$(aerospace list-windows --workspace "$workspace" --count)

    local id_flag=()
    if [[ -n "$window_id" ]]; then
        id_flag=(--window-id "$window_id")
    fi

    if (( count == 3 )); then
        aerospace join-with "${id_flag[@]}" left
    elif (( count == 4 )); then
        aerospace move "${id_flag[@]}" left
        aerospace join-with "${id_flag[@]}" left
    elif (( count >= 5 )); then
        overflow_to_sibling_workspace "$workspace" "$window_id"
    fi
}

overflow_to_sibling_workspace() {
    local current_workspace="$1"
    local window_id="${2:-}"
    local monitor_id target ws ws_count

    monitor_id=$(aerospace list-workspaces --all --format '%{workspace}%{tab}%{monitor-id}' \
        | awk -F'\t' -v ws="$current_workspace" '$1 == ws { print $2; exit }')

    target=""
    while IFS= read -r ws; do
        [[ "$ws" == "$current_workspace" ]] && continue
        ws_count=$(aerospace list-windows --workspace "$ws" --count)
        if (( ws_count < 4 )); then
            target="$ws"
            break
        fi
    done < <(aerospace list-workspaces --monitor "$monitor_id" --format '%{workspace}')

    if [[ -z "$target" ]]; then
        return 0
    fi

    if [[ -n "$window_id" ]]; then
        aerospace move-node-to-workspace --window-id "$window_id" --focus-follows-window "$target"
    else
        aerospace move-node-to-workspace --focus-follows-window "$target"
    fi
    route_new_window "$target" "$window_id"
}

route_new_window "${1:-focused}" "${2:-}"
