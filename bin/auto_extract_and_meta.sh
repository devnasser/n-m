#!/usr/bin/env bash
# auto_extract_and_meta.sh <BC_ID>
set -euo pipefail
CID="$1"
ARCHIVE="/workspace/ai_megred_learn/shard/${CID}.tar.zst"
DEST="/workspace/ai_megred_learn/shard/${CID}"

if [[ ! -f "$ARCHIVE" ]]; then
  echo "Archive $ARCHIVE not found" >&2
  exit 1
fi

mkdir -p "$DEST"
# Extract with multithread zstd
 tar --use-compress-program="zstd -T0 -d" -xf "$ARCHIVE" -C "$DEST"

# Update meta
/workspace/bin/gen_meta.sh "$CID" "$DEST"
META="/workspace/ai_megred_learn/bc_metadata/${CID}.meta.json"
if [[ -f "$META" ]]; then
  tmp=$(mktemp)
  jq '. + {has_payload: true}' "$META" > "$tmp" && mv "$tmp" "$META"
fi

# Trigger merge
flock -n /tmp/merge.lock /workspace/bin/merge_and_validate.sh &

echo "Processed $CID"