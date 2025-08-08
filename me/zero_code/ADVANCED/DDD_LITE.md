### DDD‑Lite

- طبقات: Domain (Entities/ValueObjects/Services) + App (UseCases) + Infra (Eloquent/HTTP)
- تجنّب تسريب Eloquent إلى الدومين؛ استخدم عقود Repositories
- Value Objects للحقول الحرجة (Email/Price)