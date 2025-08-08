#!/usr/bin/env python3
import os
import sys
import json
import time
import hashlib
from datetime import datetime, timezone
from pathlib import Path
from fnmatch import fnmatch
from concurrent.futures import ProcessPoolExecutor, as_completed

TRAN_ROOT = Path('/workspace/tran')
ME_ROOT = Path('/workspace/me')
ME_ROOT.mkdir(parents=True, exist_ok=True)

CACHE_FILE = ME_ROOT / '.knowledge_cache.json'
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


def load_cache() -> dict:
    if CACHE_FILE.exists():
        try:
            return json.loads(CACHE_FILE.read_text())
        except Exception:
            return {}
    return {}


def save_cache(cache: dict) -> None:
    CACHE_FILE.write_text(json.dumps(cache, ensure_ascii=False))


def build_filters():
    include = [s.strip() for s in os.getenv('KN_INCLUDE_GLOBS', '').split(',') if s.strip()]
    ignore = [s.strip() for s in os.getenv('KN_IGNORE_GLOBS', '').split(',') if s.strip()]
    def is_included(rel_path: str) -> bool:
        rp = rel_path.replace('\\', '/')
        if include:
            ok = any(fnmatch(rp, pat) for pat in include)
            if not ok:
                return False
        if ignore:
            if any(fnmatch(rp, pat) for pat in ignore):
                return False
        return True
    return is_included


def collect_metadata_parallel(root: Path, prev_map: dict, max_workers: int, is_included) -> tuple[list, list]:
    files = []
    changed_paths = []
    to_hash = []
    stat_map = {}
    for p in list_files(root):
        rel = str(p.relative_to(root))
        if not is_included(rel):
            continue
        try:
            st = p.stat()
            stat_map[rel] = (p, st.st_size, st.st_mtime)
            prev = prev_map.get(rel)
            if not (prev and prev.get('size') == st.st_size and prev.get('mtime') == st.st_mtime):
                to_hash.append(rel)
        except Exception as e:
            files.append({'abs_path': str(p), 'rel_path': rel, 'error': str(e)})
            changed_paths.append(rel)
    sha_map = {}
    if to_hash:
        workers = max(1, min(max_workers, len(to_hash)))
        with ProcessPoolExecutor(max_workers=workers) as pool:
            future_to_rel = {pool.submit(sha256_file, stat_map[rel][0]): rel for rel in to_hash}
            for fut in as_completed(future_to_rel):
                rel = future_to_rel[fut]
                try:
                    sha_map[rel] = fut.result()
                except Exception:
                    sha_map[rel] = ''
                changed_paths.append(rel)
    for rel, (p, size, mtime) in stat_map.items():
        prev = prev_map.get(rel)
        sha = sha_map.get(rel) if rel in sha_map else (prev.get('sha256') if prev else '')
        files.append({
            'abs_path': str(p),
            'rel_path': rel,
            'size': size,
            'mtime': mtime,
            'sha256': sha,
        })
    return files, changed_paths


def collect_from_changes_only(root: Path, prev_map: dict, changes: list[str], max_workers: int, is_included):
    # Start from previous map as baseline
    files_map: dict[str, dict] = {k: dict(v) for k, v in prev_map.items() if is_included(k)}
    need_hash: list[str] = []
    changed_paths: list[str] = []
    for rel in changes:
        if not is_included(rel):
            # If previously tracked and now ignored, drop it
            files_map.pop(rel, None)
            continue
        p = root / rel
        if p.exists() and p.is_file():
            try:
                st = p.stat()
                prev = prev_map.get(rel)
                if not (prev and prev.get('size') == st.st_size and prev.get('mtime') == st.st_mtime):
                    need_hash.append(rel)
                # Update basic stats (sha filled later if needed)
                files_map[rel] = {
                    'abs_path': str(p),
                    'rel_path': rel,
                    'size': st.st_size,
                    'mtime': st.st_mtime,
                    'sha256': prev.get('sha256') if prev else ''
                }
                changed_paths.append(rel)
            except Exception as e:
                files_map[rel] = {
                    'abs_path': str(p),
                    'rel_path': rel,
                    'error': str(e)
                }
                changed_paths.append(rel)
        else:
            # Deleted
            if rel in files_map:
                files_map.pop(rel, None)
                changed_paths.append(rel)
    # Hash needed files in parallel
    if need_hash:
        workers = max(1, min(max_workers, len(need_hash)))
        with ProcessPoolExecutor(max_workers=workers) as pool:
            future_to_rel = {pool.submit(sha256_file, (root / rel)): rel for rel in need_hash}
            for fut in as_completed(future_to_rel):
                rel = future_to_rel[fut]
                try:
                    sha = fut.result()
                except Exception:
                    sha = ''
                if rel in files_map:
                    files_map[rel]['sha256'] = sha
    files_list = list(files_map.values())
    files_list.sort(key=lambda x: x.get('rel_path', ''))
    return files_list, changed_paths


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
    readme = root / 'tran' / 'README.md'
    if readme.exists():
        parts.append("#### README")
        txt = read_text(readme)
        parts.append("```")
        parts.append(txt[:2000])
        parts.append("```")
    info_dir = root / 'tran' / 'info'
    if info_dir.exists():
        for name in ['KNOWLEDGE_INDEX.md', 'ROOT_STRUCTURE.md']:
            p = info_dir / name
            if p.exists():
                parts.append(f"#### info/{name}")
                parts.append("```")
                parts.append(read_text(p)[:2000])
                parts.append("```")
    kb_dir = root / 'tran' / 'kb'
    if kb_dir.exists():
        for name in ['CHANGELOG.md', 'all_knowledge.md']:
            p = kb_dir / name
            if p.exists():
                parts.append(f"#### kb/{name}")
                parts.append("```")
                parts.append(read_text(p)[:2000])
                parts.append("```")
    api_yaml = root / 'tran' / 'api' / 'openapi.yaml'
    api_info = summarize_openapi(api_yaml)
    parts.append("#### API (openapi.yaml)")
    parts.append("| الحقل | القيمة |")
    parts.append("|---|---|")
    for k in ['title', 'version', 'paths_approx']:
        parts.append(f"| {k} | {api_info.get(k)} |")
    ds_csv = root / 'tran' / 'datasets' / 'sample_posts.csv'
    ds_info = summarize_csv(ds_csv)
    parts.append("#### datasets/sample_posts.csv")
    parts.append("| الحقل | القيمة |")
    parts.append("|---|---|")
    for k in ['rows', 'columns', 'header']:
        parts.append(f"| {k} | {ds_info.get(k)} |")
    ci_file = root / 'tran' / 'ci' / 'github-actions.yml'
    if ci_file.exists():
        parts.append("#### CI/github-actions.yml")
        parts.append("```")
        parts.append(read_text(ci_file)[:2000])
        parts.append("```")
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


def write_if_changed(path: Path, content: str) -> bool:
    try:
        if path.exists() and path.read_text(encoding='utf-8', errors='replace') == content:
            return False
    except Exception:
        pass
    path.write_text(content)
    return True


def read_changes_from_env(root: Path):
    changed_env = os.getenv('KN_CHANGED_PATHS', '').strip()
    changed_file = os.getenv('KN_CHANGED_FILE', '').strip()
    changes: list[str] = []
    if changed_file:
        p = Path(changed_file)
        if p.exists():
            try:
                lines = [ln.strip() for ln in p.read_text().splitlines() if ln.strip()]
                # normalize to rel
                for ln in lines:
                    try:
                        rel = str(Path(ln).resolve().relative_to(root.resolve())) if ln.startswith('/') else ln
                    except Exception:
                        rel = ln
                    changes.append(rel)
            except Exception:
                pass
    if changed_env:
        for part in changed_env.split(','):
            s = part.strip()
            if s:
                changes.append(s)
    # unique preserve order
    seen = set()
    uniq = []
    for c in changes:
        if c not in seen:
            uniq.append(c)
            seen.add(c)
    return uniq


def main():
    if not TRAN_ROOT.exists():
        print(f"tran folder not found at {TRAN_ROOT}")
        sys.exit(1)

    is_included = build_filters()
    prev_cache = load_cache()
    prev_map = {f.get('rel_path'): f for f in prev_cache.get('files', [])} if isinstance(prev_cache, dict) else {}

    now = datetime.now(UTC).strftime('%Y-%m-%dT%H:%M:%SZ')
    try:
        max_workers = int(os.getenv('KN_CONCURRENCY', str(os.cpu_count() or 2)))
    except Exception:
        max_workers = os.cpu_count() or 2

    changes = read_changes_from_env(TRAN_ROOT)
    if changes:
        files_meta, changed_paths = collect_from_changes_only(TRAN_ROOT, prev_map, changes, max_workers, is_included)
    else:
        files_meta, changed_paths = collect_metadata_parallel(TRAN_ROOT, prev_map, max_workers, is_included)

    knowledge = {
        'generated_at_utc': now,
        'source_root': str(TRAN_ROOT),
        'file_count': len(files_meta),
        'files': files_meta,
    }
    knowledge_path = ME_ROOT / 'knowledge.json'
    wrote_json = write_if_changed(knowledge_path, json.dumps(knowledge, ensure_ascii=False, indent=2))

    index_md = generate_index_md(TRAN_ROOT, files_meta)
    wrote_index = write_if_changed(ME_ROOT / 'INDEX.md', index_md)

    summary_md = generate_summary_md(TRAN_ROOT)
    wrote_summary = write_if_changed(ME_ROOT / 'SUMMARY.md', summary_md)

    cache_obj = {
        'files': files_meta,
        'updated_at_utc': now,
    }
    save_cache(cache_obj)

    (ME_ROOT / 'latest_run.txt').write_text(now)

    print(f"Knowledge built at {now}; files={len(files_meta)}; changed={len(changed_paths)}; writes={{'json':wrote_json,'index':wrote_index,'summary':wrote_summary}}")


if __name__ == '__main__':
    main()