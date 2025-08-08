### تصميم API (REST)

- مبادئ:
  - موارد: `posts`, `users`, ... باستخدام Resource Controllers.
  - ترقيم: `GET /api/posts?page=1`، فرز/بحث عبر query params.
  - النسخ: رأس `Accept: application/vnd.zero.v1+json` أو مسار `/api/v1/...`.
  - الأخطاء: RFC7807 اختياري، وإلا JSON موحّد `{ message, errors }`.

- الأمن:
  - مفاتيح وصول (Bearer tokens)، قيود معدل (Throttle). 
  - سياسات Laravel للتفويض.

- استجابات:
  - استخدم Resources/Transformers لإخفاء تفاصيل DB.