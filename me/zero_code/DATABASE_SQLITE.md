### SQLite مع Laravel

- الاتصال والإعداد: راجع `STACK_SETUP.md`.

- نمذجة الجداول:
  - استخدم Types المناسبة: integer, text, real, blob.
  - مفاتيح أساسية AUTOINCREMENT نادراً؛ اكتفِ بـ integer primary key.
  - العلاقات عبر مفاتيح خارجية وتفعيلها في Laravel migrations.

- مؤشرات (Indexes):
  - أضف فهارس للحقول المستخدمة في WHERE/ORDER BY/JOIN.
  - مثال Migration:
    ```php
    Schema::table('posts', function (Blueprint $table) {
        $table->index(['published_at']);
        $table->index(['author_id', 'published_at']);
    });
    ```

- وضع WAL:
  - يحسّن التوازي والسرعة:
    ```php
    DB::statement('PRAGMA journal_mode=WAL;');
    DB::statement('PRAGMA synchronous=NORMAL;');
    ```

- بحث نص كامل (FTS5):
  - أنشئ جدول ظل للبحث، أو استخدم raw statements للـ virtual table.

- الأداء:
  - استخدم pagination، caching (file)، تجنّب SELECT *.
  - عمليات الكتابة المجمّعة ضمن معاملات Transactions.

- نسخ احتياطي/استعادة:
  - النسخ ملفيّاً مع قفل القراءة.