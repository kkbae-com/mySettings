#!/usr/bin/env bash

# Only acts when the focused workspace has exactly one window. Toggles that
# window: tiling -> floats + centers it to 33% of its screen; floating ->
# restores it to tiling. No-op with more than one window in the workspace.
# Bound to alt-shift-c in .aerospace.toml.

set -euo pipefail

window_count=$(aerospace list-windows --workspace focused --count)

if [[ "$window_count" -ne 1 ]]; then
    exit 0
fi

layout=$(aerospace list-windows --workspace focused --format '%{window-layout}')

if [[ "$layout" == "floating" ]]; then
    aerospace layout tiling
    exit 0
fi

aerospace layout floating

osascript -l JavaScript <<'EOF'
ObjC.import('AppKit')

function run() {
    const relSize = 0.70

    const se = Application('System Events')
    const frontProcess = se.applicationProcesses.where({ frontmost: true })[0]
    const win = frontProcess.windows[0]

    const [winX, winY] = win.position()
    const [winW, winH] = win.size()
    const centerX = winX + winW / 2
    const centerY = winY + winH / 2

    const screens = $.NSScreen.screens
    const screenCount = screens.count
    const primaryHeight = screens.objectAtIndex(0).frame.size.height

    let target = null
    for (let i = 0; i < screenCount; i++) {
        const f = screens.objectAtIndex(i).frame
        const left = f.origin.x
        const top = primaryHeight - (f.origin.y + f.size.height)
        const right = left + f.size.width
        const bottom = top + f.size.height

        if (centerX >= left && centerX < right && centerY >= top && centerY < bottom) {
            target = { left: left, top: top, width: f.size.width, height: f.size.height }
            break
        }
    }

    if (!target) {
        const f = screens.objectAtIndex(0).frame
        target = { left: f.origin.x, top: 0, width: f.size.width, height: primaryHeight }
    }

    const newW = target.width * relSize
    const newH = target.height * relSize
    const newX = target.left + (target.width - newW) / 2
    const newY = target.top + (target.height - newH) / 2

    win.position = [newX, newY]
    win.size = [newW, newH]
}
EOF
