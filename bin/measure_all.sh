#!/usr/bin/env bash
set -euo pipefail

# Comprehensive performance measurement script
# Outputs raw logs and a Markdown report.

start_epoch=$(date +%s)
ts_utc=$(date -u +%Y%m%d-%H%M%S)
reports_dir="/workspace/reports/perf-${ts_utc}"
mkdir -p "${reports_dir}"
report_md="${reports_dir}/report.md"
raw_dir="${reports_dir}/raw"
mkdir -p "${raw_dir}"

num_cpus=$(nproc || echo 1)

note() { echo "[$(date -u +%H:%M:%S)] $*"; }
run_save() {
  local name="$1"; shift
  local outfile="${raw_dir}/${name}.txt"
  note "Running: ${name}"
  {
    echo "$ $*"
    eval "$@"
  } &>"${outfile}" || true
}

# 1) System information
run_save sys_lscpu lscpu
run_save sys_free "free -h"
run_save sys_uname "uname -a"
run_save sys_df "df -h /"
run_save sys_lsblk "lsblk -o NAME,SIZE,TYPE,MOUNTPOINT"

# 2) CPU benchmarks (OpenSSL)
if command -v openssl >/dev/null 2>&1; then
  run_save cpu_openssl "openssl version"
  run_save cpu_speed "openssl speed -multi ${num_cpus} rsa2048 aes-256-cbc sha256"
else
  printf 'OpenSSL not found on PATH.\n' >"${raw_dir}/cpu_speed.txt"
fi

# 3) Disk throughput via dd (write/read)
# Use direct I/O where possible and sync to flush caches
DD_FILE="/workspace/.dd.test"
run_save disk_write "dd if=/dev/zero of=${DD_FILE} bs=1M count=2048 oflag=direct conv=fdatasync 2>&1 | tail -n 1"
run_save disk_read "dd if=${DD_FILE} of=/dev/null bs=1M iflag=direct 2>&1 | tail -n 1; rm -f ${DD_FILE}"

# 4) Filesystem micro-benchmark (small files)
cat >"${raw_dir}/fs_micro.py" <<'PY'
import os, time, shutil, json
base = '/workspace/.fs_micro'
shutil.rmtree(base, ignore_errors=True)
os.makedirs(base, exist_ok=True)
num = 5000
start=time.time()
for i in range(num):
    with open(f"{base}/f{i}", 'wb') as f:
        f.write(os.urandom(1024))
create_time = time.time()-start
start=time.time()
for i in range(num):
    os.stat(f"{base}/f{i}")
stat_time = time.time()-start
start=time.time()
for i in range(num):
    with open(f"{base}/f{i}", 'rb') as f:
        _ = f.read()
read_time = time.time()-start
shutil.rmtree(base, ignore_errors=True)
result = {
  "files": num,
  "create_s": round(create_time, 6),
  "stat_s": round(stat_time, 6),
  "read_s": round(read_time, 6)
}
print(json.dumps(result))
PY
run_save fs_micro "python3 ${raw_dir}/fs_micro.py"

# 5) Network measurements
# a) HTTP timing segments (Hetzner)
run_save net_http_timing "curl -L -o /dev/null -s -w 'dns: %{time_namelookup}s connect: %{time_connect}s tls: %{time_appconnect}s ttfb: %{time_starttransfer}s total: %{time_total}s\n' https://speed.hetzner.de/100MB.bin"
# b) Download throughput (Cloudflare)
run_save net_download_cf "curl -L -o /dev/null -s -w 'total: %{time_total}s size: %{size_download} bytes speed: %{speed_download} B/s\n' https://speed.cloudflare.com/__down?bytes=104857600"
# c) Ping may be not permitted; try and capture error
run_save net_ping "ping -c 5 -n 1.1.1.1"

# Helper: extract values for the Markdown report
get_dd_speed_mb() {
  # Input: dd summary line -> prints last field MB/s or B/s normalized to MB/s
  local line="$1"
  # Example: "2147483648 bytes (2.1 GB, 2.0 GiB) copied, 4.53445 s, 474 MB/s"
  # Extract the speed value and unit
  local speed unit
  speed=$(echo "$line" | awk -F, '{print $3}' | awk '{print $(NF-1)}' 2>/dev/null)
  unit=$(echo "$line" | awk -F, '{print $3}' | awk '{print $NF}' 2>/dev/null)
  case "$unit" in
    MB/s) printf "%s" "$speed" ;;
    GB/s) awk -v s="$speed" 'BEGIN{printf "%.2f", s*1024}' ;;
    kB/s) awk -v s="$speed" 'BEGIN{printf "%.2f", s/1024}' ;;
    B/s)  awk -v s="$speed" 'BEGIN{printf "%.6f", s/1048576}' ;;
    *)    printf "%s" "$speed" ;;
  esac
}

parse_fs_micro_json() {
  local json_file="$1"
  python3 - <<PY
import json,sys
with open(sys.argv[1]) as f:
    data = f.read().strip()
print(data)
PY "${json_file}"
}

# OpenSSL summary lines
openssl_summary_sha=$(grep -E '^sha256\s' -m1 "${raw_dir}/cpu_speed.txt" || true)
openssl_summary_aes=$(grep -E '^aes-256-cbc\s' -m1 "${raw_dir}/cpu_speed.txt" || true)
# RSA summary block (last section lines containing 'rsa  2048 bits')
openssl_rsa_line=$(grep -E '^rsa\s+2048 bits' -m1 "${raw_dir}/cpu_speed.txt" || true)

# dd speeds
dd_write_line=$(cat "${raw_dir}/disk_write.txt" || true)
dd_read_line=$(cat "${raw_dir}/disk_read.txt" || true)
write_mb=$(get_dd_speed_mb "${dd_write_line}")
read_mb=$(get_dd_speed_mb "${dd_read_line}")

# fs micro
fs_json=$(parse_fs_micro_json "${raw_dir}/fs_micro.txt" 2>/dev/null || echo '{}')
create_s=$(echo "${fs_json}" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("create_s",""))' 2>/dev/null || true)
stat_s=$(echo "${fs_json}" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("stat_s",""))' 2>/dev/null || true)
read_s=$(echo "${fs_json}" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("read_s",""))' 2>/dev/null || true)
files_n=$(echo "${fs_json}" | python3 -c 'import sys,json;print(json.load(sys.stdin).get("files",""))' 2>/dev/null || true)

ops_per_s() {
  local n="$1"; local secs="$2"; python3 - <<PY
import sys
n=float(sys.argv[1]) if sys.argv[1] else 0
s=float(sys.argv[2]) if sys.argv[2] else 0.000001
print(f"{n/s:.0f}")
PY "$n" "$secs"
}
create_ops=$(ops_per_s "${files_n:-0}" "${create_s:-0.0}")
stat_ops=$(ops_per_s "${files_n:-0}" "${stat_s:-0.0}")
read_ops=$(ops_per_s "${files_n:-0}" "${read_s:-0.0}")

# Network results lines
net_timing=$(cat "${raw_dir}/net_http_timing.txt" | tail -n 1 || true)
net_cf=$(cat "${raw_dir}/net_download_cf.txt" | tail -n 1 || true)

# System quick summary values
cpu_model=$(grep -m1 'Model name' "${raw_dir}/sys_lscpu.txt" | awk -F: '{print $2}' | sed 's/^ *//')
cpus=$(grep -m1 '^CPU(s):' "${raw_dir}/sys_lscpu.txt" | awk -F: '{print $2}' | sed 's/^ *//')
mem_total=$(grep -m1 'Mem:' "${raw_dir}/sys_free.txt" | awk '{print $2}')
kernel=$(cat "${raw_dir}/sys_uname.txt" | awk '{print $3}')
disk_total=$(awk 'NR==2{print $2}' "${raw_dir}/sys_df.txt" 2>/dev/null || echo "")
disk_avail=$(awk 'NR==2{print $4}' "${raw_dir}/sys_df.txt" 2>/dev/null || echo "")

# Generate Markdown report
{
  echo "### النظام"
  echo "| المعيار | القيمة |"
  echo "|---|---|"
  echo "| CPU | ${cpus:-?} x ${cpu_model:-?} |"
  echo "| RAM | ${mem_total:-?} |"
  echo "| Kernel | ${kernel:-?} |"
  echo "| قرص الجذر | ${disk_total:-?} الكلي، ${disk_avail:-?} متاح |"
  echo
  echo "### CPU (OpenSSL)"
  echo "| الخوارزمية | ملخص |"
  echo "|---|---|"
  echo "| SHA-256 | ${openssl_summary_sha:-N/A} |"
  echo "| AES-256-CBC | ${openssl_summary_aes:-N/A} |"
  echo
  echo "| RSA-2048 | sign/s | verify/s |"
  echo "|---|---:|---:|"
  if [[ -n "${openssl_rsa_line}" ]]; then
    # Extract sign/s and verify/s columns (last two numbers)
    rsa_sign=$(echo "${openssl_rsa_line}" | awk '{print $(NF-3)}')
    rsa_verify=$(echo "${openssl_rsa_line}" | awk '{print $NF}')
    echo "| rsa 2048 | ${rsa_sign} | ${rsa_verify} |"
  else
    echo "| rsa 2048 | N/A | N/A |"
  fi
  echo
  echo "### قرص (تتابعي)"
  echo "| الاختبار | الحجم | الزمن/السطر | السرعة (MB/s) |"
  echo "|---|---:|---|---:|"
  echo "| كتابة (dd, direct) | 2.0 GiB | ${dd_write_line//|/} | ${write_mb:-} |"
  echo "| قراءة (dd, direct) | 2.0 GiB | ${dd_read_line//|/} | ${read_mb:-} |"
  echo
  echo "### نظام الملفات (ملفات صغيرة، ${files_n:-0} × 1KB)"
  echo "| العملية | الزمن (s) | المعدّل (ops/s) |"
  echo "|---|---:|---:|"
  echo "| إنشاء | ${create_s:-} | ${create_ops:-} |"
  echo "| stat | ${stat_s:-} | ${stat_ops:-} |"
  echo "| قراءة | ${read_s:-} | ${read_ops:-} |"
  echo
  echo "### الشبكة"
  echo "| الاختبار | الملخص |"
  echo "|---|---|"
  echo "| HTTP (Hetzner) | ${net_timing//|/} |"
  echo "| تنزيل 100MB (Cloudflare) | ${net_cf//|/} |"
  echo
  echo "- مخرجات خام مفصلة محفوظة داخل: \`${raw_dir}\`"
  echo "- وقت البدء (UTC): $(date -u -d @${start_epoch} +%Y-%m-%dT%H:%M:%SZ)"
  echo "- وقت الانتهاء (UTC): $(date -u +%Y-%m-%dT%H:%M:%SZ)"
} >"${report_md}"

# Final note with report path
echo "Report generated: ${report_md}"