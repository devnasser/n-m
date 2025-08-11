### خلاصة المعرفة المستخلصة من tran
#### README
```
# Transfer Package (`tran/`)

هذا المجلد مُقسَّم لنقل كل ما يلزم إلى أي ذكاء اصطناعي آخر:

| المجلد | المحتوى | الغرض |
|--------|---------|-------|
| `info/` | `KNOWLEDGE_INDEX.md` | كافة مصادر المعرفة. |
| `set/` | `SETUP_GUIDE.md` + سكربتات | إعداد البيئة والأداء الخارق. |
| `proj/` | `PROJECT_CATALOG.md` + `templates/` | أفكار وقوالب المشاريع. |
| `models/` | `zerocode.phar` + نماذج ONNX/PT | نماذج جاهزة للتشغيل. |
| `api/` | `openapi.yaml` | توثيق الـ API الناتج. |
| `tests/` | أمثلة اختبارات Pest | ضمان سلامة الترحيل. |
| `datasets/` | ملفات CSV/JSON عينات | بيانات تجريبية وسريعة. |
| `assets/` | صور وأيقونات توضيحية | يستخدمها التوثيق والعروض |
| `legacy/` | أرشيف الكود القديم | مرجع تاريخي |
| `kb/` | all_knowledge.md | ملف معرفة موحّد |

> بإمكانك ضغط هذا المجلد ومشاركته مع أي نظام لتحصل على كل شيء جاهزاً.
```
#### info/KNOWLEDGE_INDEX.md
```
# Knowledge Index

هذا الملف يربط جميع مصادر المعرفة المكتسبة أثناء تطوير منصة **Zero-Code 360°**.

| التصنيف | الوصف | المسار المصدر |
|---------|-------|---------------|
| Laravel Architecture | شروحات حول الحاوية، Eloquent، الأحداث | `archive/knowledge_docs/01_laravel_architecture_mastery.html` |
| Livewire 3 | خصائص محسوبة، رفع ملفات، بث حي | `archive/knowledge_docs/01_livewire_realtime_mastery.html` |
| PHP 8+ Advanced | Union Types، Fibers، JIT | `archive/knowledge_docs/01_php8_advanced_features.html` |
| Zero-Code Platform | مخططات المكوّنات، تعدد المستأجرين | `archive/knowledge_docs/01_zero_code_platform_architecture.html` |
| تلخيص الإنجاز | لوحة تقدم + الإحصاءات | `archive/knowledge_docs/MASTER_ACHIEVEMENT_SUMMARY.html` |
| تدريب 6 أسابيع | دروس أسبوعية وتمارين | `training/week*.md` |
| نصائح وملاحظات | نصائح متفرقة | `docs/tips.md` |

> ملاحظة: يمكن لأي ذكاء اصطناعي استهلاك هذه الموارد بقراءة المسارات أعلاه أو استيرادها دفعة واحدة عبر `scripts/full_refactor.sh` (قسم الأرشفة).
```
#### info/ROOT_STRUCTURE.md
```
# Original Repository Structure

يوضّح هذا الملف الشجرة المبسطة للمجلد الأم (_Workspace Root_) قبل النقل:

```
/ (root)
├── code/              # كود المشروع الأصلي قبل إعادة الهيكلة
├── src/               # src/zerocode (المحرّك بعد refactor)
├── scripts/           # سكربتات الأداء والأدوات
├── templates/         # 50 قالب JSON لمشاريع سريعة
├── training/          # منهاج تدريب 6 أسابيع
├── archive/           # مستندات HTML و PDF (المعرفة الأصلية)
├── docs/              # وثائق إضافية
├── legacy/            # كود أو ملفات قديمة مؤرشفة
├── tran/              # حزمة النقل (هذا المجلد)
└── …
```

> يساعد هذا المخطط أي فريق خارجي على فهم أين كانت المواد الأصلية داخل المستودع قبل نقلها إلى `tran/`.
```
#### kb/CHANGELOG.md
```
# CHANGELOG

All notable changes to the **Zero-Code 360° Transfer Package** will be documented in this file.

## [1.0.0] – Initial Release
### Added
- Complete `tran/` structure with knowledge, setup scripts, project templates, models, API docs, CI, datasets, assets, legacy, and tools.
- Consolidated knowledge file `all_knowledge.md`.
- Import script `tools/import.sh` for one-step installation.
- GitHub Actions CI workflow.
```
#### kb/all_knowledge.md
```
# Consolidated Knowledge (All-In-One)

> هذا الملف يدمج أبرز النقاط والمفاهيم من جميع ملفات المعرفة (HTML/MD) التي تم استخدامها أثناء تطوير منصة **Zero-Code 360°**، بحيث يستطيع أي ذكاء اصطناعي قراءته مباشرة دون الحاجة لتصفح ملفات متعددة.

## محتوى الملف

1. Laravel Architecture Essentials
2. PHP 8.2+ Advanced Features
3. Livewire 3 Highlights
4. Zero-Code 360° Architecture & Components
5. Performance Tuning Cheat-Sheet
6. Training Roadmap (6 أسابيع)
7. نصائح متفرقة (Tips)

---

## 1. Laravel Architecture Essentials

- Service Container: DI, Singleton, Lazy Loading, Contextual Binding, Auto-Resolution.
- Eloquent Patterns: Repository, Dynamic Relationships, Query Scopes.
- Event-Driven: Events, Listeners, ShouldBroadcast.
- Microservices approach using Laravel modules.

## 2. PHP 8.2+ Advanced Features

- Union & Intersection Types, readonly properties, attributes (e.g. `#[CacheResult]`).
- Fibers for async tasks.
- JIT compiler overview & benchmarks.

## 3. Livewire 3 Highlights

- Computed properties & `#[On]` listeners.
- File uploads & real-time validation.
- Pagination, Polling, Debounce.

## 4. Zero-Code 360° Architecture

- Core Engine: `SchemaBuilder`, `ComponentFactory`, `BusinessLogicEngine`, `UIGenerator`.
- Plugins: `RbacGenerator`, `GraphqlGenerator`, `PredictiveEngine`.
- Flow 360°: DB ➜ API ➜ UI ➜ Security ➜ AI.

## 5. Performance Tuning Cheat-Sheet

| أداة/إعداد | التأثير | الأمر |
|-------------|---------|-------|
| OPcache CLI | تسريع X2 | `opcache.enable_cli=1` |
| OPcache JIT | تسريع إضافي | `opcache.jit=tracing` |
| RAM-disk | I/O فائق | `mount -t tmpfs -o size=512M tmpfs /mnt/cache` |
| Composer Classmap | تسريع autoload | `composer install --optimize-autoloader` |
| Box PHAR | تشغيل فوري | `box compile -o zerocode.phar` |

## 6. Training Roadmap (6 أسابيع)

| الأسبوع | الموضوع | التمرين |
|---------|---------|---------|
| 1 | Laravel Fundamentals | CRUD مع Livewire |
| 2 | Eloquent Advanced | Query Scopes |
| 3 | Architecture Patterns | Service
```
#### API (openapi.yaml)
| الحقل | القيمة |
|---|---|
| title | Zero-Code 360° API |
| version | 1.0.0 |
| paths_approx | 2 |
#### datasets/sample_posts.csv
| الحقل | القيمة |
|---|---|
| rows | 2 |
| columns | 3 |
| header | id,title,body |
#### CI/github-actions.yml
```
name: Zero-Code CI

on: [push]

jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'
      - name: Install deps
        run: composer install --no-interaction --prefer-dist --no-progress
      - name: Run tests
        run: vendor/bin/pest --parallel
```
#### Models (models/)
- README.md (654.0 B)
#### Projects (proj/)
- PROJECT_CATALOG.md (1.0 KB)
#### Setup (set/)
- SETUP_GUIDE.md (1.4 KB)
#### Tests (tests/)
- sample_test.php (136.0 B)
#### Tools (tools/)
- import.sh (827.0 B)
#### Legacy (legacy/)
- README.md (437.0 B)
#### Assets (assets/)
- README.md (316.0 B)
#### version.json
```
{
  "transfer_package": "1.0.0",
  "zerocode_engine": "0.9.0",
  "laravel": "12.0.0",
  "php": "8.2"
}
```
