#!/usr/bin/env bash
# auto_extract_and_meta.sh <BC_ID>
set -euo pipefail
CID="$1"
# Resolve full ID if only prefix supplied
FULL_ID="$CID"
if [[ ${#CID} -le 12 ]]; then
  match=$(ls /workspace/ai_megred_learn/bc_metadata | grep "^${CID}.*\.meta\.json$" | head -n1 || true)
  if [[ -n "$match" ]]; then
    FULL_ID="${match%.meta.json}"
  fi
fi

ARCHIVE="/workspace/ai_megred_learn/shard/${FULL_ID}.tar.zst"
DEST="/workspace/ai_megred_learn/shard/${FULL_ID}"

if [[ ! -f "$ARCHIVE" ]]; then
  echo "Archive $ARCHIVE not found" >&2
  exit 1
fi

mkdir -p "$DEST"
# Extract with multithread zstd
 tar --use-compress-program="zstd -T0 -d" -xf "$ARCHIVE" -C "$DEST"

# Update meta
/workspace/bin/gen_meta.sh "$FULL_ID" "$DEST"
META="/workspace/ai_megred_learn/bc_metadata/${FULL_ID}.meta.json"
if [[ -f "$META" ]]; then
  tmp=$(mktemp)
  jq '. + {has_payload: true}' "$META" > "$tmp" && mv "$tmp" "$META"
fi

# Trigger merge
flock -n /tmp/merge.lock /workspace/bin/merge_and_validate.sh &

echo "Processed $FULL_ID"