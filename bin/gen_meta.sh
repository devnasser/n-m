#!/usr/bin/env bash
# gen_meta.sh - Generate metadata JSON for a BC resource
# Usage: gen_meta.sh <BC_ID> <RESOURCE_DIR> [OUTPUT_DIR]
#  BC_ID:        Identifier string, e.g. bc-xxxx
#  RESOURCE_DIR: Path to the resource directory to measure size, etc.
#  OUTPUT_DIR:   (optional) directory where the .meta.json will be written.
#                Defaults to /workspace/bc_metadata

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <BC_ID> <RESOURCE_DIR> [OUTPUT_DIR]" >&2
  exit 1
fi

BC_ID="$1"
RESOURCE_DIR="$2"
OUTPUT_DIR="${3:-/workspace/bc_metadata}"

if [[ ! -d "$RESOURCE_DIR" ]]; then
  echo "Error: resource directory '$RESOURCE_DIR' does not exist" >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"

# Calculate size in bytes (total of files inside RESOURCE_DIR)
SIZE_BYTES=$(du -sb "$RESOURCE_DIR" | cut -f1)

# ISO8601 UTC timestamp
EXPORTED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

META_FILE="${OUTPUT_DIR}/${BC_ID}.meta.json"

cat > "$META_FILE" <<EOF
{
  "id": "${BC_ID}",
  "name": "$(basename "$RESOURCE_DIR")",
  "version": "0.0.1",
  "type": "other",
  "description": "auto-generated metadata by gen_meta.sh",
  "size_bytes": ${SIZE_BYTES},
  "dependencies": [],
  "license": "proprietary",
  "exported_at": "${EXPORTED_AT}"
}
EOF

echo "Created metadata: ${META_FILE}"