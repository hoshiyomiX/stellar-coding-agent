#!/bin/bash
# stellar-coding-agent — Preview Bootstrap
# Deploys custom splash page and starts dev server.
# Run once per session to activate the preview panel.
#
# Usage:
#   bash skills/stellar-coding-agent/assets/boot.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

ASSET_PAGE="$SCRIPT_DIR/page.tsx"
TARGET_PAGE="$PROJECT_DIR/src/app/page.tsx"
DEV_SCRIPT="$PROJECT_DIR/.zscripts/dev.sh"

# ── Deploy custom page ──────────────────────────────────────────
if [ -f "$ASSET_PAGE" ]; then
  mkdir -p "$(dirname "$TARGET_PAGE")"
  cp "$ASSET_PAGE" "$TARGET_PAGE"
  echo "[boot] Custom page deployed → src/app/page.tsx"
else
  echo "[boot] WARNING: assets/page.tsx not found"
fi

# ── Check if dev server already running ─────────────────────────
if curl -s --connect-timeout 2 "http://localhost:3000" >/dev/null 2>&1; then
  echo "[boot] Dev server already running on port 3000"
  echo "[boot] Preview should be visible now. Refresh browser if needed."
  exit 0
fi

# ── Start dev server via existing dev.sh ────────────────────────
if [ -f "$DEV_SCRIPT" ]; then
  echo "[boot] Starting dev server via .zscripts/dev.sh ..."
  chmod +x "$DEV_SCRIPT"
  DATABASE_URL="${DATABASE_URL:-file:${PROJECT_DIR}/db/custom.db}"

  (
    cd "$PROJECT_DIR"
    nohup bash "$DEV_SCRIPT" >>"$PROJECT_DIR/.zscripts/dev.log" 2>&1 </dev/null &
    echo "$!" >"$PROJECT_DIR/.zscripts/dev.pid"
  )

  # Wait for server
  for i in $(seq 1 30); do
    if curl -s --connect-timeout 2 "http://localhost:3000" >/dev/null 2>&1; then
      echo "[boot] Dev server ready on port 3000"
      echo "[boot] Preview should be visible now. Refresh browser if needed."
      exit 0
    fi
    sleep 1
  done

  echo "[boot] WARNING: Server started but health check timed out"
  echo "[boot] Check .zscripts/dev.log for details"
  exit 1
else
  echo "[boot] ERROR: .zscripts/dev.sh not found. Run fullstack-dev init first."
  exit 1
fi
