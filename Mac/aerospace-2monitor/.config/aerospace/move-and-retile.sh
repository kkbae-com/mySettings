#!/usr/bin/env bash

# AeroSpace has no callback for "window moved to another workspace" (only
# on-window-detected, which fires for newly created windows). So manually
# sending a window to another workspace via move-node-to-workspace never
# triggered grid-layout.sh there. This script closes that gap: it captures
# the focused window's id, moves it, then calls grid-layout.sh against the
# workspace it actually landed in, targeting that window-id explicitly
# (since focus doesn't necessarily follow it).
#
# Usage: move-and-retile.sh [--follow] <target-workspace>
#   --follow   also switch the current view to the target workspace after
#              the move (matches the old 'move-node-to-workspace X',
#              'workspace X' binding pattern for alt-shift-left/right)

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

follow=false
if [[ "${1:-}" == "--follow" ]]; then
    follow=true
    shift
fi

target="$1"
window_id=$(aerospace list-windows --focused --format '%{window-id}')

if $follow; then
    aerospace move-node-to-workspace --window-id "$window_id" --focus-follows-window "$target"
else
    aerospace move-node-to-workspace --window-id "$window_id" "$target"
fi

landed_workspace=$(aerospace list-windows --all --format '%{window-id}%{tab}%{workspace}' \
    | awk -F'\t' -v id="$window_id" '$1 == id { print $2; exit }')

"$script_dir/grid-layout.sh" "$landed_workspace" "$window_id"
