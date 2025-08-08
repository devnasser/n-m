#!/usr/bin/env bash
# Import entire tran/ package into a fresh Laravel 12 project and run boosts + tests.
set -e

PROJECT_DIR=$(pwd)

echo "[tran] Copying directories..."
cp -r tran/info "$PROJECT_DIR/" 2>/dev/null || true
cp -r tran/set  "$PROJECT_DIR/" 2>/dev/null || true
cp -r tran/proj "$PROJECT_DIR/" 2>/dev/null || true
cp -r tran/models "$PROJECT_DIR/" 2>/dev/null || true
cp -r tran/api "$PROJECT_DIR/" 2>/dev/null || true
cp -r tran/tests "$PROJECT_DIR/" 2>/dev/null || true
cp -r tran/datasets "$PROJECT_DIR/" 2>/dev/null || true

# Run environment boosts
bash scripts/fast_env_boost.sh
bash scripts/ultimate_speed.sh

# Install PHP deps
composer install --no-interaction --prefer-dist --no-progress

# Run tests
vendor/bin/pest --parallel || vendor/bin/phpunit --colors

echo "[tran] Import completed successfully."