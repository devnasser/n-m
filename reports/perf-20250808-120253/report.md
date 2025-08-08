### النظام
| المعيار | القيمة |
|---|---|
| CPU | 4 x Intel(R) Xeon(R) Processor |
| RAM | 15Gi |
| Kernel | -a
6.1.147 |
| قرص الجذر | Size الكلي، Avail متاح |

### CPU (OpenSSL)
| الخوارزمية | ملخص |
|---|---|
| SHA-256 | sha256          509005.62k  1654787.52k  4095199.49k  6137779.88k  7317189.97k  7296619.86k |
| AES-256-CBC | aes-256-cbc    4425887.09k  5381151.10k  5467097.86k  5527532.89k  5469694.63k  5524176.90k |

| RSA-2048 | sign/s | verify/s |
|---|---:|---:|
| rsa 2048 | 15901.7 | 15536.0 |

### قرص (تتابعي)
| الاختبار | الحجم | الزمن/السطر | السرعة (MB/s) |
|---|---:|---|---:|
| كتابة (dd, direct) | 2.0 GiB | $ dd if=/dev/zero of=/workspace/.dd.test bs=1M count=2048 oflag=direct conv=fdatasync 2>&1  tail -n 1
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 4.70561 s, 456 MB/s |  |
| قراءة (dd, direct) | 2.0 GiB | $ dd if=/workspace/.dd.test of=/dev/null bs=1M iflag=direct 2>&1  tail -n 1; rm -f /workspace/.dd.test
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 3.15561 s, 681 MB/s |  |

### نظام الملفات (ملفات صغيرة، 0 × 1KB)
| العملية | الزمن (s) | المعدّل (ops/s) |
|---|---:|---:|
| إنشاء |  | 0 |
| stat |  | 0 |
| قراءة |  | 0 |

### الشبكة
| الاختبار | الملخص |
|---|---|
| HTTP (Hetzner) | dns: 0.200538s connect: 0.313241s tls: 0.000000s ttfb: 0.000000s total: 0.432175s |
| تنزيل 100MB (Cloudflare) | total: 0.375751s size: 104857600 bytes speed: 279061399 B/s |

- مخرجات خام مفصلة محفوظة داخل: `/workspace/reports/perf-20250808-120253/raw`
- وقت البدء (UTC): 2025-08-08T12:02:53Z
- وقت الانتهاء (UTC): 2025-08-08T12:05:19Z
