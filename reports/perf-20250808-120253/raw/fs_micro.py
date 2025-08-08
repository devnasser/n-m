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
