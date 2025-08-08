#!/usr/bin/env bash
set -euo pipefail

ROOT="/workspace"
WATCH_ROOT="$ROOT/tran"
LOG_DIR="$ROOT/me/_logs"
mkdir -p "$LOG_DIR"
PID_FILE="$ROOT/me/.knowledge_watch.pid"
SCRIPT="$ROOT/bin/knowledge_build.py"
DEBOUNCE_SECS="${DEBOUNCE_SECONDS:-0.5}"
TRIGGER_FILE="$ROOT/me/.knowledge_build.scheduled"
SENT_CHANGES="$ROOT/me/.watch_changes.tmp"
: > "$SENT_CHANGES"

need_tool() {
  command -v "$1" >/dev/null 2>&1 || { echo "missing tool: $1" >&2; return 1; }
}

if [[ ! -f "$SCRIPT" ]]; then
  echo "knowledge_build.py not found at $SCRIPT" >&2
  exit 1
fi

# Prevent multiple instances
if [[ -f "$PID_FILE" ]] && ps -p "$(cat "$PID_FILE" 2>/dev/null)" >/dev/null 2>&1; then
  echo "knowledge_watch already running with PID $(cat "$PID_FILE")" >&2
  exit 0
fi

need_tool inotifywait || { echo "Install inotify-tools (apt-get install -y inotify-tools)" >&2; exit 2; }

echo $$ > "$PID_FILE"
trap 'rm -f "$PID_FILE" "$TRIGGER_FILE"' EXIT

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] watching $WATCH_ROOT" | tee -a "$LOG_DIR/watch.log" >/dev/null

normalize_rel() {
  local p="$1"
  local rel="${p#$WATCH_ROOT/}"
  printf "%s" "$rel"
}

schedule_build() {
  if [[ -f "$TRIGGER_FILE" ]]; then
    return 0
  fi
  : > "$TRIGGER_FILE"
  (
    sleep "$DEBOUNCE_SECS"
    ts=$(date -u +%Y%m%d-%H%M%S)
    # Read and export changes
    CHANGES=$(tr '\n' ',' < "$SENT_CHANGES" | sed 's/,$//')
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] change detected -> build (changes=${CHANGES})" | tee -a "$LOG_DIR/watch.log" >/dev/null
    KN_CHANGED_PATHS="$CHANGES" ionice -c1 -n0 nice -n -5 python3 "$SCRIPT" >> "$LOG_DIR/run-$ts.log" 2>&1 || true
    : > "$SENT_CHANGES"
    rm -f "$TRIGGER_FILE"
  ) &
}

# Initial build once (no changes list)
schedule_build

inotifywait -m -r -e close_write,create,delete,move --format '%w%f %e' "$WATCH_ROOT" | while read -r path evt; do
  rel=$(normalize_rel "$path")
  echo "$rel" >> "$SENT_CHANGES"
  schedule_build
done