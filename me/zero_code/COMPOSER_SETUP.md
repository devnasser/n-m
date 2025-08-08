### Composer إعداد واعتمادية

- مثال composer.json لمشروع Laravel + Livewire + Pest:
```json
{
  "name": "acme/zero-code",
  "type": "project",
  "require": {
    "php": ">=8.2",
    "laravel/framework": "^12.0",
    "livewire/livewire": "^3.0"
  },
  "require-dev": {
    "pestphp/pest": "^3.0"
  },
  "autoload": {
    "psr-4": {"App\\": "app/"},
    "files": ["app/Support/helpers.php"]
  },
  "scripts": {
    "post-install-cmd": ["@php artisan key:generate -q || true"],
    "gen": ["@php artisan app:generate %SCHEMA%"],
    "test": ["pest --parallel"]
  },
  "config": {"optimize-autoloader": true}
}
```

- ممارسات جيدة:
  - ثبّت قيود الإصدارات semver.
  - استخدم cache Composer محليًا.
  - عرّف سكربتات gen/test/ci.