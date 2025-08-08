.PHONY: measure-all قياس-شامل
measure-all قياس-شامل:
	bash /workspace/bin/measure_all.sh

.PHONY: install-bench-tools
install-bench-tools:
	# Optional tools for extended benchmarks
	@which fio >/dev/null 2>&1 || sudo apt-get update && sudo apt-get install -y fio || true
	@python3 -c 'import numpy' >/dev/null 2>&1 || pip3 install --user numpy || true