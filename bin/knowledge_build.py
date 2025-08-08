#!/usr/bin/env python3
import os
import sys
import json
import time
import hashlib
from datetime import datetime, timezone
from pathlib import Path

TRAN_ROOT = Path('/workspace/tran')
ME_ROOT = Path('/workspace/me')
ME_ROOT.mkdir(parents=True, exist_ok=True)

UTC = timezone.utc


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def read_text(path: Path) -> str:
    try:
        return path.read_text(encoding='utf-8', errors='replace')
    except Exception as e:
        return f"<ERROR reading {path}: {e}>"


def list_files(root: Path):
    for dirpath, _, filenames in os.walk(root):
        for name in sorted(filenames):
            p = Path(dirpath) / name
            yield p


def collect_metadata(root: Path):
    files = []
    for p in list_files(root):
        try:
            st = p.stat()
            files.append({
                'abs_path': str(p),
                'rel_path': str(p.relative_to(root)),
                'size': st.st_size,
                'mtime': st.st_mtime,
                'sha256': sha256_file(p)
            })
        except Exception as e:
            files.append({
                'abs_path': str(p),
                'rel_path': str(p.relative_to(root)),
                'error': str(e)
            })
    return files


def fmt_bytes(n: int) -> str:
    step = 1024.0
    units = ['B', 'KB', 'MB', 'GB', 'TB']
    size = float(n)
    for u in units:
        if size < step:
            return f"{size:.1f} {u}"
        size /= step
    return f"{size*step:.1f} TB"


def generate_index_md(root: Path, files_meta: list) -> str:
    lines = []
    lines.append("### فهرس الملفات في tran")
    lines.append("| المسار | الحجم | آخر تعديل | SHA256 |")
    lines.append("|---|---:|---:|---|")
    for f in files_meta:
        rel = f.get('rel_path', '')
        if 'error' in f:
            lines.append(f"| {rel} | - | - | ERROR: {f['error']} |")
        else:
            size = fmt_bytes(f['size'])
            mtime = datetime.fromtimestamp(f['mtime'], UTC).strftime('%Y-%m-%d %H:%M:%S UTC')
            sha = f['sha256'][:16]
            lines.append(f"| {rel} | {size} | {mtime} | {sha}… |")
    return "\n".join(lines) + "\n"


def summarize_openapi(p: Path) -> dict:
    info = {"path": str(p), "exists": p.exists()}
    if not p.exists():
        return info
    text = read_text(p)
    # naive parse for title/version/paths count
    title = None
    version = None
    paths_count = text.count("\n  /") + text.count("\n/")
    for line in text.splitlines():
        ls = line.strip()
        if ls.startswith('title:') and title is None:
            title = ls.split(':', 1)[1].strip()
        if ls.startswith('version:') and version is None:
            version = ls.split(':', 1)[1].strip()
    info.update({"title": title, "version": version, "paths_approx": paths_count})
    return info


def summarize_csv(p: Path) -> dict:
    info = {"path": str(p), "exists": p.exists()}
    if not p.exists():
        return info
    try:
        with p.open('r', encoding='utf-8', errors='replace') as f:
            lines = f.readlines()
        header = lines[0].strip() if lines else ''
        rows = max(0, len(lines) - 1)
        cols = header.count(',') + 1 if header else 0
        info.update({"rows": rows, "columns": cols, "header": header})
    except Exception as e:
        info.update({"error": str(e)})
    return info


def generate_summary_md(root: Path) -> str:
    parts = []
    parts.append("### خلاصة المعرفة المستخلصة من tran")

    # README
    readme = root / 'tran' / 'README.md'
    if readme.exists():
        parts.append("#### README")
        txt = read_text(readme)
        parts.append("```")
        parts.append(txt[:2000])
        parts.append("```")

    # Info
    info_dir = root / 'tran' / 'info'
    if info_dir.exists():
        for name in ['KNOWLEDGE_INDEX.md', 'ROOT_STRUCTURE.md']:
            p = info_dir / name
            if p.exists():
                parts.append(f"#### info/{name}")
                parts.append("```")
                parts.append(read_text(p)[:2000])
                parts.append("```")

    # KB
    kb_dir = root / 'tran' / 'kb'
    if kb_dir.exists():
        for name in ['CHANGELOG.md', 'all_knowledge.md']:
            p = kb_dir / name
            if p.exists():
                parts.append(f"#### kb/{name}")
                parts.append("```")
                parts.append(read_text(p)[:2000])
                parts.append("```")

    # API
    api_yaml = root / 'tran' / 'api' / 'openapi.yaml'
    api_info = summarize_openapi(api_yaml)
    parts.append("#### API (openapi.yaml)")
    parts.append("| الحقل | القيمة |")
    parts.append("|---|---|")
    for k in ['title', 'version', 'paths_approx']:
        parts.append(f"| {k} | {api_info.get(k)} |")

    # Datasets
    ds_csv = root / 'tran' / 'datasets' / 'sample_posts.csv'
    ds_info = summarize_csv(ds_csv)
    parts.append("#### datasets/sample_posts.csv")
    parts.append("| الحقل | القيمة |")
    parts.append("|---|---|")
    for k in ['rows', 'columns', 'header']:
        parts.append(f"| {k} | {ds_info.get(k)} |")

    # CI
    ci_file = root / 'tran' / 'ci' / 'github-actions.yml'
    if ci_file.exists():
        parts.append("#### CI/github-actions.yml")
        parts.append("```")
        parts.append(read_text(ci_file)[:2000])
        parts.append("```")

    # Models, Projects, Setup, Tests, Tools
    for sub, title in [
        ('models', 'Models'),
        ('proj', 'Projects'),
        ('set', 'Setup'),
        ('tests', 'Tests'),
        ('tools', 'Tools'),
        ('legacy', 'Legacy'),
        ('assets', 'Assets'),
    ]:
        d = root / 'tran' / sub
        if d.exists():
            parts.append(f"#### {title} ({sub}/)")
            for p in sorted(d.glob('*')):
                if p.is_file():
                    parts.append(f"- {p.name} ({fmt_bytes(p.stat().st_size)})")

    # Version
    version_json = root / 'tran' / 'version.json'
    if version_json.exists():
        parts.append("#### version.json")
        try:
            obj = json.loads(read_text(version_json))
            parts.append("```")
            parts.append(json.dumps(obj, ensure_ascii=False, indent=2)[:2000])
            parts.append("```")
        except Exception:
            parts.append("```")
            parts.append(read_text(version_json)[:2000])
            parts.append("```")

    return "\n".join(parts) + "\n"


def main():
    if not TRAN_ROOT.exists():
        print(f"tran folder not found at {TRAN_ROOT}")
        sys.exit(1)

    now = datetime.now(UTC).strftime('%Y-%m-%dT%H:%M:%SZ')
    files_meta = collect_metadata(TRAN_ROOT)

    # Write JSON metadata
    knowledge = {
        'generated_at_utc': now,
        'source_root': str(TRAN_ROOT),
        'file_count': len(files_meta),
        'files': files_meta,
    }
    (ME_ROOT / 'knowledge.json').write_text(json.dumps(knowledge, ensure_ascii=False, indent=2))

    # Write INDEX.md
    (ME_ROOT / 'INDEX.md').write_text(generate_index_md(TRAN_ROOT, files_meta))

    # Write SUMMARY.md
    (ME_ROOT / 'SUMMARY.md').write_text(generate_summary_md(TRAN_ROOT))

    # Write heartbeat
    (ME_ROOT / 'latest_run.txt').write_text(now)

    print(f"Knowledge built at {now}; files: {len(files_meta)}; output -> {ME_ROOT}")


if __name__ == '__main__':
    main()