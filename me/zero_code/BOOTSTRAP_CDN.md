### Bootstrap 5 عبر CDN (بدون أدوات بناء)

- تضمين في الـ layout:
```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.rtl.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
```

- مبادئ تصميم:
  - استخدم Grid وUtilities لتخطيط سريع.
  - حافظ على تباين الألوان وARIA attributes لعناصر تفاعلية.
  - للأيقونات: `bootstrap-icons` عبر CDN عند الحاجة.

- قوالب جاهزة:
  - Navbar، Sidebar، Cards، Forms، Tables مع فئات `.form-floating`, `.table-striped`.