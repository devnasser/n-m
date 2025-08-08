### أداء وضبط

- PHP Opcache/JIT: تفعيل CLI، jit=tracing، memory=256M
- قياس: time/memory، Xdebug profiler (بدون GUI إذا لزم)
- SQLite:
  - EXPLAIN QUERY PLAN لتحليل الاستعلام
  - فهارس مركّبة، تجنّب LIKE البادئ بـ %
  - WAL + synchronous=NORMAL
- Livewire:
  - Debounce/Paginate، تقليل إعادة الرندر
- Caching:
  - Cache Aside، مفاتيح واضحة وTTL