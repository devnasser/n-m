# رسالة مُوحَّدة لإرسالها إلى جلسة Cursor الخاصّة بالعضو
# تنفّذ كامل دورة التهيئة والجمع والضغط والرفع من دون مسارات $HOME.

### التعليمات الكاملة لتسليم المحاور إلى ai_megred_learn
⚠️ ملاحظة: لا حاجة إلى إعادة تشغيل الخادم أو فتح جلسة جديدة بعد تنفيذ الأوامر؛ كل خطوة تصبح فعّالة فور التنفيذ.

```bash
# ========= (أ) تهيئة البيئة للسرعة القصوى =========
sudo apt-get update -y \
 && sudo apt-get install -y zstd pigz aria2 rsync parallel inotify-tools jq
export ZSTD_NBTHREADS=$(nproc)
export OMP_NUM_THREADS=$(nproc)

sudo mkdir -p /mnt/ram
ram_g=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 / 1024 / 2 ))
[[ $ram_g -lt 1 ]] && ram_g=1
mountpoint -q /mnt/ram || sudo mount -t tmpfs -o size=${ram_g}G tmpfs /mnt/ram
export TMPDIR=/mnt/ram

# ========= (ب) تنظيم المحاور =========
# أنشئ مجلد باسم معرّفك داخل /workspace/spacework
mkdir -p /workspace/spacework/bc-*/   # عدّل الاسم عند الحاجة
mkdir -p /workspace/spacework/shared_knowledge/  # (اختياري)

# انسخ الملفات الخمسة عشر إلى /workspace/spacework/bc-*/ بالأسماء EXACT.
# ضع مواد إضافيّة (إن وجدت) داخل shared_knowledge/.

# ========= (ج) manifest للتحقّق =========
cd /workspace/spacework/bc-*/
sha256sum * > manifest.sha256
cd /workspace/spacework

# ========= (د) ضغط بأقصى سرعة =========
name=$(basename $(ls -d /workspace/spacework/bc-* | head -n1))
tar -I 'zstd -19 -T0' -cf ${name}.tar.zst  ${name}/  shared_knowledge/ 2>/dev/null

# ========= (هـ) رفع إلى مخزوننا المركزي =========
mkdir -p /workspace/ai_megred_learn/shard/
cp -v ${name}.tar.zst /workspace/ai_megred_learn/shard/

# (بديل مع SSH)
# rsync -avP --compress-level=9 ${name}.tar.zst user@HOST:/workspace/ai_megred_learn/shard/

# ========= (و) تلقائيًا بعد الرفع =========
# inotify يفكّ الأرشيف ويحدّث meta ويُدمِج knowledge؛ ستظهر ✅ خلال ≤ 15 ثانية.
```