#!/usr/bin/env bash
set -euo pipefail
META_DIR="/workspace/ai_megred_learn/bc_metadata"
OUT_DIR="/workspace/ai_megred_learn"

export TMPDIR="/mnt/ram"

# Validate meta files in parallel
find $META_DIR -name '*.meta.json' | parallel -j$(nproc) 'jq empty {}'

# Merge using tmpfs temp file then move
tmpfile=$(mktemp)
jq -s '.' $META_DIR/*.meta.json > "$tmpfile"
mv "$tmpfile" $OUT_DIR/merged-knowledge.json

echo "Merged knowledge $(date -u)"