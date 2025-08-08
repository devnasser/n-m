#!/usr/bin/env bash
set -euo pipefail

ROOT="/workspace"
LOG_DIR="$ROOT/me/_logs"
mkdir -p "$LOG_DIR"
PID_FILE="$ROOT/me/.knowledge_sync.pid"
SCRIPT="$ROOT/bin/knowledge_build.py"

if [[ ! -f "$SCRIPT" ]]; then
  echo "knowledge_build.py not found at $SCRIPT" >&2
  exit 1
fi

# Prevent multiple instances
if [[ -f "$PID_FILE" ]] && ps -p "$(cat "$PID_FILE" 2>/dev/null)" >/dev/null 2>&1; then
  echo "knowledge_sync already running with PID $(cat "$PID_FILE")" >&2
  exit 0
fi

echo $$ > "$PID_FILE"
trap 'rm -f "$PID_FILE"' EXIT

while true; do
  ts=$(date -u +%Y%m%d-%H%M%S)
  echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] running knowledge build" | tee -a "$LOG_DIR/sync.log" >/dev/null
  python3 "$SCRIPT" >> "$LOG_DIR/run-$ts.log" 2>&1 || true
  sleep 5
done