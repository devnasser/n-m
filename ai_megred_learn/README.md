# AI Merged Learn Knowledge Base

This directory contains merged metadata for 16 BC resources.

## Files
- bc_metadata/: individual .meta.json files
- merged-knowledge.json: combined metadata array
- validation_report.txt: JSON validation results
- CHANGELOG.md: operation history
- summary.txt: brief project summary

## Shared upload directory (`shard`)
All team members can place their 15 required transfer-learning axes inside the shared directory:
```
/workspace/ai_megred_learn/shard/<BC-ID>/
```
The folder is writable (chmod 777). After uploading, run:
```
/workspace/bin/gen_meta.sh <BC-ID> /workspace/ai_megred_learn/shard/<BC-ID>
```
This will refresh the meta file and trigger automatic validation/merge.
