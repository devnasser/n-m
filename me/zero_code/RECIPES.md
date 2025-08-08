### وصفات عملية سريعة

- توليد CRUD من SCHEMA.json
  1) حدد الجداول والحقول والعلاقات.
  2) شغّل مولّد المخطط (Schema Builder) لإنتاج migrations/models.
  3) شغّل مولّد الواجهة (Component Factory) لإنتاج Livewire CRUD.

- ربط Livewire مع Bootstrap عبر CDN
  - استخدم Layout من `STACK_SETUP.md` وادمج المكوّنات.

- تفعيل WAL في SQLite
  ```php
  DB::statement('PRAGMA journal_mode=WAL;');
  DB::statement('PRAGMA synchronous=NORMAL;');
  ```

- اختبار سريع بـ Pest
  ```php
  test('post can be created', function () {
      $post = \App\Models\Post::factory()->create();
      expect($post->id)->not->toBeNull();
  });
  ```