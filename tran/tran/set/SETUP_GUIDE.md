# Performance & Environment Setup

هذا الدليل يجمع كافة الإعدادات و السكربتات التي تجعل الأداء «خارق» ويمكن إعادة استخدامها في بيئات ذكاء اصطناعي أخرى.

| السكربت / الملف | الوظيفة | مسار المصدر |
|-----------------|----------|--------------|
| `fast_env_boost.sh` | تثبيت PHP/Composer + RAM-disk + OPcache CLI | `scripts/fast_env_boost.sh` |
| `ultimate_speed.sh` | Preload + inotify watch + Pest parallel + Git hooks | `scripts/ultimate_speed.sh` |
| `full_boost.sh` | حزمة شاملة: OPcache JIT + Box + كرون | `scripts/full_boost.sh` |
| `extra_speed_boost.sh` | ضبطات دقيقة (file_cache، JIT tuning) | `scripts/extra_speed_boost.sh` |
| `env_health_check.sh` | تقرير صحة البيئة | `scripts/env_health_check.sh` |
| `benchmark_team_speed.sh` | قياس زمن توليد المنصة | `scripts/benchmark_team_speed.sh` |
| `status.sh` | عرض حالة المشروع نصيًّا | `scripts/status.sh` |
| `Makefile` | أوامر gen / test / coverage / up | `Makefile` |

## طريقة التصدير

يمكن نسخ المجلد `scripts/` بالكامل مع هذا الدليل إلى أي مشروع Laravel 12 آخر ثم تنفيذ:

```bash
bash scripts/fast_env_boost.sh && bash scripts/ultimate_speed.sh
```

> سيؤدي ذلك إلى تهيئة البيئة تلقائياً بأقصى سرعة.