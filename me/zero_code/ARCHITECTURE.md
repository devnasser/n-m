### معمارية منصة Zero‑Code (عالية المستوى)

- الأهداف:
  - توليد CRUD كاملة (DB ➜ API ➜ UI) بسرعة، مع أقل تبعيات.
  - الاعتماد على PHP/Laravel، SQLite، Livewire، Bootstrap عبر CDN.
  - دون npm/node/docker.

- المكوّنات الأساسية:
  - Core Engine
    - Schema Builder: تفسير مخططات JSON (جداول/حقول/علاقات) وتوليد Migrations + Models.
    - Component Factory: توليد Blade + Livewire Components استناداً إلى المخطط.
    - Business Logic Engine: قواعد التحقق، سياسات، Events/Listeners.
    - UI Generator: قوالب Bootstrap 5 عبر CDN (RTL-ready)، تنسيق نماذج وجداول.
  - Adapters
    - DB Adapter (SQLite): اتصال، Migrations/Seeders، فهارس/FTS5/WAL.
    - Auth/RBAC: سياسات Laravel Gates/Policies، أدوار مبسطة.
    - Cache/Queue: تخزين ملفات، Queue sync/db عند الحاجة.
  - API Layer
    - Resource Controllers + Requests + Transformers.
    - نسخة API وقيود السرعة ومفاتيح وصول (Token/Bearer).
  - UI Layer
    - Blade Layout أساسي + Bootstrap CDN + Livewire Components.
    - عناصر: قائمة، عرض، إنشاء/تعديل، بحث، ترقيم، رفع ملفات.
  - Tooling
    - Composer scripts (build/test/gen/schema).
    - Pest لاختبارات الوحدة والتكامل.
    - GitHub Actions: تثبيت، cache، اختبار.

- التدفقات:
  1) SCHEMA.json ➜ Schema Builder ➜ Migrations/Models/Policies
  2) SCHEMA.json ➜ Component Factory ➜ Livewire CRUD
  3) DB (SQLite) ➜ API Controllers ➜ Blade/Livewire UI

- الحدود والواجهات:
  - كل وحدة معزولة خلف واجهات: Repository Ports، Service Contracts، Events.
  - لا تداخل مباشر بين UI وDB؛ المرور عبر Services/Repositories.

- الأداء:
  - SQLite WAL + فهارس مناسبة.
  - OPcache CLI/JIT مفعّل.
  - عدم تحميل أصول ثقيلة؛ استخدام CDN فقط.