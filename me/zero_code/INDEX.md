### فهرس محاور التعلّم لمنصة Zero‑Code (بدون npm/node/docker)

| المحور | الوصف | الملف |
|---|---|---|
| المعمارية العامة | مكوّنات المنصة وعلاقاتها وحدودها | ARCHITECTURE.md |
| حزمة التقنية والإعداد | خطوات تجهيز البيئة والأدوات المطلوبة فقط | STACK_SETUP.md |
| الوحدات والمكوّنات | تعريف الوحدات وحدود المسؤولية والواجهات | MODULES.md |
| قواعد البيانات (SQLite) | نمذجة، فهارس، WAL، FTS5، الأداء | DATABASE_SQLITE.md |
| Laravel + SQLite | ضبط الاتصال والهجرة والبذور والسياسات | STACK_SETUP.md |
| Livewire بلا أدوات بناء | مكوّنات تفاعلية باستخدام CDN فقط | LIVEWIRE_NO_NPM.md |
| Bootstrap عبر CDN | التصميم والتصميمات مع RTL وإتاحة | BOOTSTRAP_CDN.md |
| إدارة الاعتمادية (Composer) | تنظيم composer.json وautoload والسكربتات | COMPOSER_SETUP.md |
| تصميم API | REST/Resource Controllers والأمن والنسخ | API_DESIGN.md |
| أوامر Make المقترحة | أوامر أتمتة للإعداد والبناء والفحص | MAKE_TARGETS.md |

> هذه المحاور مصمّمة للالتزام الصارم: لا npm، لا nodejs، لا docker. كل شيء عبر PHP/Composer وCDN.