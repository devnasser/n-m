### أمن متقدّم

- تهديدات شائعة: XSS/CSRF/SQLi/SSRF/IDOR
- Laravel:
  - CSRF: حماية تلقائية في Forms (`@csrf`)
  - Validation: قواعد صارمة وأنواع، Sanitization قبل التخزين
  - Policies/Gates: وصول على مستوى السجل/المجال
  - Rate Limiting: `ThrottleRequests`
- كلمات المرور: Argon2id بإعدادات قوية
- سرية المفاتيح: .env محلي، لا تسجّل الأسرار في السجلات
- سجلات أمنية: أحداث auth، تغييرات حساسة