### أوامر Make المقترحة (بدون npm/node/docker)

```make
.PHONY: init db migrate seed serve pest

init:
	composer create-project laravel/laravel zeroapp || true
	cd zeroapp && composer require livewire/livewire:^3 && composer require pestphp/pest --dev && php artisan pest:install || true

db:
	cd zeroapp && mkdir -p database && : > database/database.sqlite && \
	sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=sqlite/' .env && \
	sed -i 's|^DB_DATABASE=.*|DB_DATABASE=database/database.sqlite|' .env

migrate:
	cd zeroapp && php artisan migrate

seed:
	cd zeroapp && php artisan db:seed || true

serve:
	cd zeroapp && php artisan serve --host=0.0.0.0 --port=8000

pest:
	cd zeroapp && ./vendor/bin/pest --parallel
```

- ملاحظة: الأصول عبر CDN داخل `resources/views/layouts/app.blade.php`.