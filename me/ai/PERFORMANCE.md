### أداء مرجعي


- CPU (OpenSSL): SHA-256 ≈ 7.28 GB/s, AES-256-CBC ≈ 5.55 GB/s, RSA-2048 (sign≈16k/s, verify≈264k/s)

- Disk: write ≈ 474 MB/s, read ≈ 722 MB/s

- Network: 100MB ≈ 0.325s (~2.6 Gbps)

- FS small files: create 5k ≈ 0.181s, read ≈ 0.033s

- التقرير الشامل عبر: `bin/measure_all.sh`
