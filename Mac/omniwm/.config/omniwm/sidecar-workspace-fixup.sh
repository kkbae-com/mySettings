#!/bin/bash
# Runs on every OmniWM display-changed event (see the LaunchAgent in
# Library/LaunchAgents/). OmniWM's static config can only say a workspace's
# home is "main", "secondary" (whichever external is connected), or one
# specific physical display - it can't say "secondary, unless that's the
# Sidecar, in which case main". settings.toml keeps the HP Z27-correct
# layout (1-5 main / 6-9 secondary) as the durable config; this script
# explicitly pushes workspaces 1-5 onto the Sidecar and 6-9 onto the
# built-in display while the Sidecar is connected, and explicitly pushes
# them back (1-5 built-in, 6-9 whatever external is connected, if any)
# when it's not - using the same temporary runtime override as the in-app
# "Move Workspace to Monitor" action. It must handle BOTH directions
# explicitly: that override does not clear itself just because the
# topology changed back, so a script that only acted in one direction
# would leave workspaces stuck on the wrong monitor after switching away
# from Sidecar. Direction (left/right) is computed from live display
# geometry each run rather than hardcoded, since Sidecar sits left of the
# built-in display in this setup while the HP Z27 sits to its right.

OMNIWMCTL=/Applications/OmniWM.app/Contents/MacOS/omniwmctl

"$OMNIWMCTL" query displays --format json 2>/dev/null | python3 -c '
import json, subprocess, sys

OMNIWMCTL = "'"$OMNIWMCTL"'"

try:
    data = json.load(sys.stdin)
except ValueError:
    sys.exit(0)

displays = data.get("result", {}).get("payload", {}).get("displays", [])
built_in = next((d for d in displays if d.get("isMain")), None)
external = next((d for d in displays if not d.get("isMain")), None)

if built_in is None or external is None:
    sys.exit(0)

sidecar_connected = "Sidecar" in external.get("name", "")
target_1_5 = external if sidecar_connected else built_in
target_6_9 = built_in if sidecar_connected else external

def direction(from_display, to_display):
    return "right" if to_display["frame"]["x"] > from_display["frame"]["x"] else "left"

workspaces_result = subprocess.run(
    [OMNIWMCTL, "query", "workspaces", "--format", "json", "--fields", "raw-name,display"],
    capture_output=True, text=True,
)
try:
    workspaces = json.loads(workspaces_result.stdout)["result"]["payload"]["workspaces"]
except (ValueError, KeyError):
    sys.exit(0)
current_display_by_ws = {w["rawName"]: w["display"]["id"] for w in workspaces}

def nudge(ws_names, target):
    for ws in ws_names:
        current_id = current_display_by_ws.get(ws)
        if current_id == target["id"]:
            continue
        current = built_in if current_id == built_in["id"] else external
        subprocess.run(
            [OMNIWMCTL, "workspace", "move-to-monitor", ws, direction(current, target), "--force"],
            capture_output=True,
        )

nudge([str(n) for n in range(1, 6)], target_1_5)
nudge([str(n) for n in range(6, 10)], target_6_9)
'
