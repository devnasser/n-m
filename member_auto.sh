#!/usr/bin/env bash
# member_auto.sh  —  سكربت واحد ينفّذ كل الخطوات تلقائياً داخل /workspace
# Usage:  ./member_auto.sh <BC-ID>  [EXTRA_DIR]
#   <BC-ID>    معرّف العضو كاملاً (bc-xxxxxxxx-xxxx-…)
#   EXTRA_DIR  مسار اختياري لمجلد معرفة إضافيّة (shared_knowledge)

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <BC-ID> [EXTRA_DIR]" >&2; exit 1; fi
BC_ID="$1"; shift || true
EXTRA_DIR="${1:-}"

WORK_ROOT="/workspace"
MEMBER_WS="$WORK_ROOT/spacework"
MODEL_DIR="$MEMBER_WS/$BC_ID"
SHARD_DIR="$WORK_ROOT/ai_megred_learn/shard"
LOG="$WORK_ROOT/member_upload_${BC_ID}.log"

########################################
## 1) تهيئة البيئة للسرعة القصوى
########################################
if command -v sudo &>/dev/null; then
  sudo apt-get update -y
  sudo apt-get install -y zstd pigz aria2 rsync parallel inotify-tools jq || true
fi
export ZSTD_NBTHREADS="${ZSTD_NBTHREADS:-$(nproc)}"
export OMP_NUM_THREADS="${OMP_NUM_THREADS:-$(nproc)}"

sudo mkdir -p /mnt/ram || true
mem_g=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 / 1024 ))
size_g=$(( mem_g / 2 )); [[ $size_g -lt 1 ]] && size_g=1
mountpoint -q /mnt/ram || sudo mount -t tmpfs -o size=${size_g}G tmpfs /mnt/ram || true
export TMPDIR=/mnt/ram

echo "[INFO] البيئة جاهزة (Threads=$(nproc), tmpfs=${size_g}G)" | tee "$LOG"

########################################
## 2) التحقق من وجود المحاور
########################################
MANDATORY=(weights.bin config.json tokenizer.json io_schema.json train_data_info.txt \
  hyperparams.json fine_tune.sh requirements.txt baseline_metrics.txt LICENSE.txt README.md \
  safety.md checkpoint.ckpt postprocess.py CHANGELOG.md)
missing=0
for f in "${MANDATORY[@]}"; do
  if [[ ! -f "$MODEL_DIR/$f" ]]; then
    echo "[ERR] مفقود: $MODEL_DIR/$f" | tee -a "$LOG"; missing=1
  fi
done
if [[ $missing -eq 1 ]]; then
  echo "[FATAL] بعض المحاور غير موجودة. أضفها ثم أعد تشغيل السكربت." | tee -a "$LOG"
  exit 1
fi

########################################
## 3) نسخ الملفات إلى tmpfs وتجميعها
########################################
TMP=$(mktemp -d)
cp -v "$MODEL_DIR"/* "$TMP/" | tee -a "$LOG"
if [[ -n "$EXTRA_DIR" && -d "$EXTRA_DIR" ]]; then
  cp -vr "$EXTRA_DIR" "$TMP/shared_knowledge" | tee -a "$LOG"
fi
(cd "$TMP" && sha256sum * > manifest.sha256)

echo "[INFO] الملفات جاهزة في $TMP" | tee -a "$LOG"

########################################
## 4) الضغط بأقصى سرعة
########################################
ARCHIVE="${BC_ID}.tar.zst"
(zstd -19 -T0 >/dev/null 2>&1 || true)

tar -I 'zstd -19 -T0' -cf "$ARCHIVE" -C "$TMP" .

########################################
## 5) رفع الأرشيف إلى المخزون المركزي
########################################
mkdir -p "$SHARD_DIR"
cp -v "$ARCHIVE" "$SHARD_DIR/" | tee -a "$LOG"

echo "[✓] تم رفع $ARCHIVE إلى $SHARD_DIR بنجاح" | tee -a "$LOG"

echo "كل شيء اكتمل. سيتم دمج المحاور في مركز المعرفة خلال ثوانٍ."