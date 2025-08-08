### Playbook: Blog App (بدون npm)

- SCHEMA:
```json
{"tables":[{"name":"posts","columns":[{"name":"title","type":"text"},{"name":"body","type":"text"},{"name":"published_at","type":"datetime","nullable":true}]}]}
```
- خطوات:
  1) توليد Migrations/Model/Factory.
  2) Resource Controller + Requests.
  3) Livewire Table + Form.
  4) فهرس على `published_at`.
  5) اختبارات Pest للوحدات والتكامل.