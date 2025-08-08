### Playbook: حجز شاليهات

- الجداول: chalets, bookings, users
- قواعد: عدم تداخل التواريخ لنفس الشاليه
- Livewire: تقويم بسيط + نموذج حجز
- API: `POST /api/bookings` مع تحقق المدى الزمني
- فهرس مركّب: bookings(chalet_id, start_date, end_date)