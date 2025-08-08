### موثوقية ومرونة

- Retries + Exponential Backoff لطلبات HTTP
- Idempotency keys لعمليات الإنشاء الحسّاسة
- Circuit Breaker (عميل HTTP): غلق مؤقت عند الفشل المتكرر
- مهام متأخرة: Queue sync/db، إعادة المحاولة عند الفشل