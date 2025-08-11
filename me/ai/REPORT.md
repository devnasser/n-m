تاريخ التوليد (UTC): 2025-08-11T02:20:53Z


### البيئة


````
Architecture:                            x86_64
CPU op-mode(s):                          32-bit, 64-bit
Address sizes:                           46 bits physical, 57 bits virtual
Byte Order:                              Little Endian
CPU(s):                                  4
On-line CPU(s) list:                     0-3
Vendor ID:                               GenuineIntel
Model name:                              Intel(R) Xeon(R) Processor
CPU family:                              6
Model:                                   207
Thread(s) per core:                      1
Core(s) per socket:                      4
Socket(s):                               1
Stepping:                                2
BogoMIPS:                                4800.00
Flags:                                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc pebs bts rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq dtes64 ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single ssbd ibrs ibpb stibp ibrs_enhanced fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves avx_vnni avx512_bf16 wbnoinvd arat avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid bus_lock_detect cldemote movdiri movdir64b fsrm md_clear serialize tsxldtrk amx_bf16 avx512_fp16 amx_tile amx_int8 flush_l1d arch_capabilities
Hypervisor vendor:                       KVM
Virtualization type:                     full
L1d cache:                               192 KiB (4 instances)
L1i cache:                               128 KiB (4 instances)
L2 cache:                                8 MiB (4 instances)
L3 cache:                                320 MiB (1 instance)
NUMA node(s):                            1
NUMA node0 CPU(s):                       0-3
Vulnerability Gather data sampling:      Not affected
Vulnerability Indirect target selection: Not affected
Vulnerability Itlb multihit:             Not affected
Vulnerability L1tf:                      Not affected
Vulnerability Mds:                       Not affected
Vulnerability Meltdown:                  Not affected
Vulnerability Mmio stale data:           Not affected
Vulnerability Reg file data sampling:    Not affected
Vulnerability Retbleed:                  Not affected
Vulnerability Spec rstack overflow:      Not affected
Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
Vulnerability Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:                Mitigation; Enhanced / Automatic IBRS; IBPB conditional; PBRSB-eIBRS SW sequence; BHI BHI_DIS_S
Vulnerability Srbds:                     Not affected
Vulnerability Tsa:                       Not affected
Vulnerability Tsx async abort:           Mitigation; TSX disabled
````

````
total        used        free      shared  buff/cache   available
Mem:            15Gi       1.1Gi       9.2Gi        10Mi       5.6Gi        14Gi
Swap:             0B          0B          0B
````

````
Linux cursor 6.1.147 #1 SMP PREEMPT_DYNAMIC Tue Aug  5 21:01:56 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux
````


### الأدوات


````
Python 3.13.3
OpenSSL 3.4.1 11 Feb 2025 (Library: OpenSSL 3.4.1 11 Feb 2025)
PHP 8.4.5 (cli) (built: Jul 14 2025 18:20:32) (NTS)
Copyright (c) The PHP Group
Composer version 2.8.6 2025-02-25 13:03:50
````


### أداء مرجعي


- CPU (OpenSSL): SHA-256 ≈ 7.28 GB/s, AES-256-CBC ≈ 5.55 GB/s, RSA-2048 (sign≈16k/s, verify≈264k/s)

- Disk: write ≈ 474 MB/s, read ≈ 722 MB/s

- Network: 100MB ≈ 0.325s (~2.6 Gbps)

- FS small files: create 5k ≈ 0.181s, read ≈ 0.033s

- التقرير الشامل عبر: `bin/measure_all.sh`


### محرّك التعلّم


- نمط: inotify (إن فُعّل) أو polling قابل للضبط

- كتابة شرطية + Cache للبصمات + تحديث انتقائي

- المخرجات: `me/knowledge.json`, `me/INDEX.md`, `me/SUMMARY.md`

### إحصاءات


- عدد الملفات: 17

- آخر توليد: 2025-08-11T02:20:53Z

### قائمة الملفات


| المسار | الحجم | SHA256 |
|---|---:|---|
| tran/README.md | 1184 | 1558d18d379cf561… |
| tran/version.json | 102 | 8a7bbe7729f0f6bd… |
| tran/info/KNOWLEDGE_INDEX.md | 1333 | 790668552ed60ec1… |
| tran/info/ROOT_STRUCTURE.md | 1048 | 95fb924302c2e3e0… |
| tran/ci/github-actions.yml | 391 | fec03f05a6192d7f… |
| tran/models/README.md | 654 | f35ab0cae37c70e8… |
| tran/legacy/README.md | 437 | 9ca4609de507f391… |
| tran/api/openapi.yaml | 960 | 9bbd5d1b63b44bfa… |
| tran/set/SETUP_GUIDE.md | 1477 | e9ca8dfde687d576… |
| tran/tests/sample_test.php | 136 | c0e22bcf673dae63… |
| tran/proj/PROJECT_CATALOG.md | 1029 | b091cf5c401c45a4… |
| tran/assets/README.md | 316 | c079d5072e26880c… |
| tran/datasets/sample_posts.csv | 68 | 5fba2b1ce2de9c5f… |
| tran/tools/import.sh | 827 | 10374943814290a3… |
| tran/kb/CHANGELOG.md | 430 | f9d242e4d6c91cf4… |
| tran/kb/_latency_test.md | 0 | e3b0c44298fc1c14… |
| tran/kb/all_knowledge.md | 2926 | d29b8284ab0f66a5… |


### API


- وثيقة: `tran/api/openapi.yaml`

- مسارات عامة: `/api/{model}`, `/api/{model}/{id}`


### البيانات


- `tran/datasets/sample_posts.csv`: 3 أعمدة، 2 صف
