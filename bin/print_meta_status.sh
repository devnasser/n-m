#!/usr/bin/env bash
# print_meta_status.sh - Print table of BC metadata status
# Usage: simply run the script; it scans ai_megred_learn/bc_metadata for *.meta.json files

BC_META_DIR="/workspace/ai_megred_learn/bc_metadata"

BC_IDS=(
  bc-01b3d259-761d-4b02-808b-bb8564a36ded
  bc-2a36493e-cecb-41f8-9649-fbaa8065651b
  bc-29647012-64a3-410a-8551-5829d66c5c2f
  bc-36b47a15-eb80-4e9d-b43a-92a03d37dd68
  bc-53e6b4fb-f99d-4529-8009-87cded370c2e
  bc-6f51d46b-acaf-4420-bfcc-dde383262ffd
  bc-66385910-81dd-4a15-a5c2-898ca178f28f
  bc-757ca27c-5f17-4639-be3a-c40db5ad84cb
  bc-769fce79-ac2e-47ac-9b4b-dcd441c51f57
  bc-b8a7ba53-02bb-4085-8b00-f48ba8692c72
  bc-c6862013-0867-4580-a63e-ec3dcfe80612
  bc-cd787b2b-846c-408f-af2e-8a5e6dcb7034
  bc-d53b7194-4c63-47f4-bbec-9c3d1733c0da
  bc-d9db207a-9c0f-4c8f-9d0e-6765fb09fe17
  bc-f2de85d5-4b15-44df-b29e-67063e1ee43e
  bc-ac204b85-e66f-47bd-b94f-5a72258e758b
)

printf "| %-38s | %-11s |\n" "المعرّف (BC-ID)" "حالة الرد"
printf "|%s|%s|\n" "--------------------------------------" "-------------"
for id in "${BC_IDS[@]}"; do
  if [[ -f "${BC_META_DIR}/${id}.meta.json" ]]; then
    status="✅ مستلم"
  else
    status="❌ غير مستلم"
  fi
  printf "| %-38s | %-11s |\n" "$id" "$status"
done