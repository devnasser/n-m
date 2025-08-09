#!/usr/bin/env bash
set -euo pipefail
META_DIR="/workspace/ai_megred_learn/bc_metadata"
OUT_DIR="/workspace/ai_megred_learn"

# Validate meta files in parallel
ls $META_DIR/*.meta.json | parallel -j$(nproc) 'jq empty {}' ::: {}

# Merge
jq -s '.' $META_DIR/*.meta.json > $OUT_DIR/merged-knowledge.json

echo "Merged knowledge $(date -u)"