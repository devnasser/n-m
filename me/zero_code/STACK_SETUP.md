### إعداد الحزمة التقنية (بدون npm/node/docker)

- المتطلبات:
  - PHP ≥ 8.2 (مفعّل OPcache/JIT اختياري).
  - Composer ≥ 2.6.

- إنشاء مشروع Laravel (اختياري):
  - باستخدام Composer مباشرة داخل مجلد العمل:
    ```bash
    composer create-project laravel/laravel zeroapp
    cd zeroapp
    ```

- إعداد SQLite:
  - في ملف `.env`:
    ```ini
    DB_CONNECTION=sqlite
    DB_DATABASE=database/database.sqlite
    ```
  - أنشئ قاعدة البيانات الفارغة:
    ```bash
    mkdir -p database && : > database/database.sqlite
    php artisan migrate
    ```

- تثبيت Livewire (بدون npm):
  ```bash
  composer require livewire/livewire:^3
  ```
  - في Blade layout (مثال `resources/views/layouts/app.blade.php`):
    ```blade
    <!doctype html>
    <html lang="ar" dir="rtl">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Zero‑Code</title>
      <!-- Bootstrap 5 RTL via CDN -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" rel="stylesheet">
      @livewireStyles
    </head>
    <body class="bg-light">
      <div class="container py-4">
        @yield('content')
      </div>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
      <script src="https://unpkg.com/alpinejs" defer></script>
      @livewireScripts
    </body>
    </html>
    ```

- Bootstrap عبر CDN:
  - لا حاجة لـ npm؛ استخدم روابط CDN أعلاه.

- Pest للاختبارات:
  ```bash
  composer require pestphp/pest --dev
  php artisan pest:install
  ```

- ملاحظات:
  - لا npm/node/docker. كل الأصول عبر CDN.
  - يمكن إضافة سياسات/حراس Auth لاحقاً حسب الحاجة.