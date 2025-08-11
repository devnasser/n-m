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
| SHA-256 | sha256          501521.32k  1684933.59k  4095447.64k  6268530.01k  7401174.36k  7413918.38k |
| AES-256-CBC | aes-256-cbc    4484231.16k  5427392.51k  5508336.64k  5566936.41k  5513966.93k  5578921.30k |

| RSA-2048 | sign/s | verify/s |
|---|---:|---:|
| rsa 2048 | 16082.9 | 15705.4 |

### قرص (تتابعي)
| الاختبار | الحجم | الزمن/السطر | السرعة (MB/s) |
|---|---:|---|---:|
| كتابة (dd, direct) | 2.0 GiB | $ dd if=/dev/zero of=/workspace/.dd.test bs=1M count=2048 oflag=direct conv=fdatasync 2>&1  tail -n 1
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 4.33098 s, 496 MB/s |  |
| قراءة (dd, direct) | 2.0 GiB | $ dd if=/workspace/.dd.test of=/dev/null bs=1M iflag=direct 2>&1  tail -n 1; rm -f /workspace/.dd.test
2147483648 bytes (2.1 GB, 2.0 GiB) copied, 3.17003 s, 677 MB/s |  |

### نظام الملفات (ملفات صغيرة، 0 × 1KB)
| العملية | الزمن (s) | المعدّل (ops/s) |
|---|---:|---:|
| إنشاء |  | 0 |
| stat |  | 0 |
| قراءة |  | 0 |

### الشبكة
| الاختبار | الملخص |
|---|---|
| HTTP (Hetzner) | dns: 0.296704s connect: 0.402328s tls: 0.000000s ttfb: 0.000000s total: 0.514281s |
| تنزيل 100MB (Cloudflare) | total: 0.430990s size: 104857600 bytes speed: 243294740 B/s |

- مخرجات خام مفصلة محفوظة داخل: `/workspace/reports/perf-20250811-022057/raw`
- وقت البدء (UTC): 2025-08-11T02:20:57Z
- وقت الانتهاء (UTC): 2025-08-11T02:23:22Z
