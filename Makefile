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

.PHONY: setup-fast setup-ultimate setup-full setup-extra setup-health setup-bench setup-status setup-super
setup-fast:
	bash /workspace/scripts/fast_env_boost.sh

setup-ultimate:
	bash /workspace/scripts/ultimate_speed.sh

setup-full:
	bash /workspace/scripts/full_boost.sh

setup-extra:
	bash /workspace/scripts/extra_speed_boost.sh

setup-health:
	bash /workspace/scripts/env_health_check.sh

setup-bench:
	bash /workspace/scripts/benchmark_team_speed.sh

setup-status:
	bash /workspace/scripts/status.sh

setup-super:
	@echo "🚀 Activating SUPER PROFESSIONAL MODE..."
	@bash /workspace/scripts/super_professional_mode.sh
	@python3 /workspace/scripts/parallel_optimizer.py

.PHONY: me-watch-start me-watch-stop
me-watch-start:
	chmod +x /workspace/bin/knowledge_watch.sh
	nohup /workspace/bin/knowledge_watch.sh >/workspace/me/_logs/nohup.watch.out 2>&1 & echo $$! >/workspace/me/.knowledge_watch.launch.pid || true
	@echo "knowledge watch requested to start (inotify)"

me-watch-stop:
	@if [ -f /workspace/me/.knowledge_watch.pid ]; then kill `cat /workspace/me/.knowledge_watch.pid` || true; fi
	@if [ -f /workspace/me/.knowledge_watch.launch.pid ]; then kill `cat /workspace/me/.knowledge_watch.launch.pid` || true; fi
	@rm -f /workspace/me/.knowledge_watch.pid /workspace/me/.knowledge_watch.launch.pid || true
	@echo "knowledge watch stopped"