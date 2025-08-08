#!/usr/bin/env python3
import json, subprocess, shutil
from pathlib import Path
from datetime import datetime, timezone

ROOT = Path('/workspace')
ME = ROOT / 'me'
AI = ME / 'ai'
AI.mkdir(parents=True, exist_ok=True)
UTC = timezone.utc


def sh(cmd: str) -> str:
    try:
        out = subprocess.check_output(cmd, shell=True, stderr=subprocess.DEVNULL)
        return out.decode('utf-8', errors='replace').strip()
    except Exception:
        return ''


def read_json(p: Path):
    try:
        return json.loads(p.read_text())
    except Exception:
        return {}


def write(p: Path, content: str):
    p.write_text(content)


def section(title: str) -> str:
    return f"### {title}\n\n"


def build_environment_md() -> str:
    lines = []
    lines.append(section('البيئة'))
    lscpu = sh('lscpu')
    free = sh('free -h')
    uname = sh('uname -a')
    lines.append('````\n' + lscpu + '\n````\n')
    lines.append('````\n' + free + '\n````\n')
    lines.append('````\n' + uname + '\n````\n')
    return '\n'.join(lines)


def build_tools_md() -> str:
    lines = []
    lines.append(section('الأدوات'))
    py = sh('python3 -V')
    ossl = sh('openssl version')
    php = sh('php -v | head -n 2')
    comp = sh('composer -V')
    lines.append('````\n' + '\n'.join([py, ossl, php, comp]) + '\n````\n')
    return '\n'.join(lines)


def build_learning_engine_md(knowledge):
    files = knowledge.get('files', [])
    lines = []
    lines.append(section('محرّك التعلّم'))
    lines.append('- نمط: inotify (إن فُعّل) أو polling قابل للضبط\n')
    lines.append('- كتابة شرطية + Cache للبصمات + تحديث انتقائي\n')
    lines.append('- المخرجات: `me/knowledge.json`, `me/INDEX.md`, `me/SUMMARY.md`\n')
    lines.append(section('إحصاءات'))
    lines.append(f"- عدد الملفات: {knowledge.get('file_count','?')}\n")
    lines.append(f"- آخر توليد: {knowledge.get('generated_at_utc','?')}\n")
    lines.append(section('قائمة الملفات'))
    lines.append('| المسار | الحجم | SHA256 |\n|---|---:|---|')
    for f in files:
        if 'error' in f: continue
        rel = f.get('rel_path','')
        size = f.get('size',0)
        sha = (f.get('sha256','') or '')[:16]
        lines.append(f"| {rel} | {size} | {sha}… |")
    return '\n'.join(lines) + '\n'


def build_performance_md() -> str:
    lines = []
    lines.append(section('أداء مرجعي'))
    lines.append('- CPU (OpenSSL): SHA-256 ≈ 7.28 GB/s, AES-256-CBC ≈ 5.55 GB/s, RSA-2048 (sign≈16k/s, verify≈264k/s)\n')
    lines.append('- Disk: write ≈ 474 MB/s, read ≈ 722 MB/s\n')
    lines.append('- Network: 100MB ≈ 0.325s (~2.6 Gbps)\n')
    lines.append('- FS small files: create 5k ≈ 0.181s, read ≈ 0.033s\n')
    lines.append('- التقرير الشامل عبر: `bin/measure_all.sh`\n')
    return '\n'.join(lines)


def build_api_md(knowledge):
    lines = []
    lines.append(section('API'))
    lines.append('- وثيقة: `tran/api/openapi.yaml`\n')
    lines.append('- مسارات عامة: `/api/{model}`, `/api/{model}/{id}`\n')
    return '\n'.join(lines)


def build_datasets_md():
    lines = []
    lines.append(section('البيانات'))
    lines.append('- `tran/datasets/sample_posts.csv`: 3 أعمدة، 2 صف\n')
    return '\n'.join(lines)


def main():
    knowledge = read_json(ME / 'knowledge.json')
    now = datetime.now(UTC).strftime('%Y-%m-%dT%H:%M:%SZ')

    # INDEX
    write(AI / 'INDEX.md', """
### AI Reference (مرجع الذكاء الاصطناعي)
- REPORT.md: تقرير موحّد للبيئة/الأداء/المعرفة
- ENVIRONMENT.md: تفاصيل البيئة
- TOOLS.md: الأدوات والإصدارات
- LEARNING_ENGINE.md: محرّك التعلّم والمخرجات
- PERFORMANCE.md: أرقام مرجعية
- API.md: نقاط API المتاحة
- DATASETS.md: مصادر البيانات
- KNOWLEDGE_SUMMARY.md: خلاصة المعرفة الحالية
""".strip() + "\n")

    # REPORT
    report = []
    report.append(f"تاريخ التوليد (UTC): {now}\n")
    report.append(build_environment_md())
    report.append(build_tools_md())
    report.append(build_performance_md())
    report.append(build_learning_engine_md(knowledge))
    report.append(build_api_md(knowledge))
    report.append(build_datasets_md())
    write(AI / 'REPORT.md', '\n\n'.join(report))

    write(AI / 'ENVIRONMENT.md', build_environment_md())
    write(AI / 'TOOLS.md', build_tools_md())
    write(AI / 'PERFORMANCE.md', build_performance_md())
    write(AI / 'LEARNING_ENGINE.md', build_learning_engine_md(knowledge))
    write(AI / 'API.md', build_api_md(knowledge))
    write(AI / 'DATASETS.md', build_datasets_md())

    # Copy SUMMARY
    src_summary = ME / 'SUMMARY.md'
    if src_summary.exists():
        shutil.copyfile(src_summary, AI / 'KNOWLEDGE_SUMMARY.md')

    print(f"AI reference generated at {AI}")

if __name__ == '__main__':
    main()