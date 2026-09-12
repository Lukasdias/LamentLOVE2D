#!/usr/bin/env bash
#
# Launch the game locally.
#
# Works on native Linux/macOS and inside WSL. In WSL, LÖVE must render through
# WSLg's Wayland socket: the Windows-host DISPLAY (VcXsrv/X410) either shows no
# window or fails GLX context creation. Detected automatically.
#
# Usage:
#   ./run.sh              launch
#   ./run.sh --debug      forward args to love (f1 console / error output)
#   LOVE=love11 ./run.sh  override the binary
#
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

LOVE="${LOVE:-love}"
if ! command -v "$LOVE" >/dev/null 2>&1; then
	echo "error: '$LOVE' not found in PATH" >&2
	echo "install love2d: https://love2d.org/ (or set LOVE=/path/to/love)" >&2
	exit 1
fi

if [[ -S /mnt/wslg/runtime-dir/wayland-0 ]]; then
	exec env -u DISPLAY \
		SDL_VIDEODRIVER=wayland \
		XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir \
		WAYLAND_DISPLAY=wayland-0 \
		LIBGL_ALWAYS_SOFTWARE=1 \
		"$LOVE" . "$@"
fi

exec "$LOVE" . "$@"
