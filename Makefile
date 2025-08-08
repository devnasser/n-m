.PHONY: measure-all قياس-شامل
measure-all قياس-شامل:
	bash /workspace/bin/measure_all.sh

.PHONY: install-bench-tools
install-bench-tools:
	# Optional tools for extended benchmarks
	@which fio >/dev/null 2>&1 || sudo apt-get update && sudo apt-get install -y fio || true
	@python3 -c 'import numpy' >/dev/null 2>&1 || pip3 install --user numpy || true

.PHONY: me-build me-start me-stop
me-build:
	python3 /workspace/bin/knowledge_build.py

me-start:
	chmod +x /workspace/bin/knowledge_sync.sh
	nohup /workspace/bin/knowledge_sync.sh >/workspace/me/_logs/nohup.out 2>&1 & echo $$! >/workspace/me/.knowledge_sync.launch.pid || true
	@echo "knowledge sync requested to start (check /workspace/me/_logs)"

me-stop:
	@if [ -f /workspace/me/.knowledge_sync.pid ]; then kill `cat /workspace/me/.knowledge_sync.pid` || true; fi
	@if [ -f /workspace/me/.knowledge_sync.launch.pid ]; then kill `cat /workspace/me/.knowledge_sync.launch.pid` || true; fi
	@rm -f /workspace/me/.knowledge_sync.pid /workspace/me/.knowledge_sync.launch.pid || true
	@echo "knowledge sync stopped"