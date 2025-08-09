#!/usr/bin/env bash
set -euo pipefail
SHARD="/workspace/ai_megred_learn/shard"
LOG="/workspace/ai_megred_learn/shard/inotify.log"

echo "Starting inotify monitor on $SHARD" | tee -a "$LOG"
inotifywait -m -e close_write,move "$SHARD" |
while read -r dir event file; do
  [[ "$file" == *.tar.zst ]] || continue
  CID="${file%.tar.zst}"
  echo "Detected upload for $CID" | tee -a "$LOG"
  /workspace/bin/auto_extract_and_meta.sh "$CID"
done