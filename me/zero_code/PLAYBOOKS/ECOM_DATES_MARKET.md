### Playbook: سوق التمور (Minimal)

- الجداول: products, orders, order_items, users
- Livewire: صفحة قائمة منتجات + سلة بسيطة (جلسة)
- سياسات: المستخدم لا يرى طلبات غيره
- API: `GET /api/products`, `POST /api/orders`
- فهارس: products(name, price), orders(user_id, created_at)