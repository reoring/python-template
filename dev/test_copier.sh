#!/usr/bin/env bash
set -euo pipefail

# This script smoke-tests the Copier template using uv.
# It generates a project into a temp directory, syncs deps, and verifies imports.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR%/dev}"

# Allow overriding output dir and template variables via env/args
OUT_DIR="${1:-}"
if [[ -z "${OUT_DIR}" ]]; then
  OUT_DIR="$(mktemp -d -t copier-gen-XXXX)"
fi

PROJECT_NAME="${PROJECT_NAME:-Weather Agent}"
PROJECT_SLUG="${PROJECT_SLUG:-weather-agent}"
PACKAGE_NAME="${PACKAGE_NAME:-weather_agent}"
PYTHON_VERSION="${PYTHON_VERSION:-3.10}"

echo "[test] template: ${TEMPLATE_DIR}"
echo "[test] out dir:  ${OUT_DIR}"

# Ensure uv/uvx is available
if ! command -v uv >/dev/null 2>&1; then
  echo "[test] installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  if [[ -f "$HOME/.local/bin/env" ]]; then source "$HOME/.local/bin/env"; fi
fi
UVX_PATH="$(command -v uvx || echo "$HOME/.local/bin/uvx")"

echo "[test] generating project with Copier..."
"$UVX_PATH" --from copier copier copy --force --trust \
  -d project_name="${PROJECT_NAME}" \
  -d project_slug="${PROJECT_SLUG}" \
  -d package_name="${PACKAGE_NAME}" \
  -d python_version="${PYTHON_VERSION}" \
  "${TEMPLATE_DIR}" "${OUT_DIR}"

cd "${OUT_DIR}"

echo "[test] syncing dependencies (uv sync)..."
uv sync

echo "[test] skipping .env preparation (no external APIs required)"

echo "[test] detecting package name..."
PKG_NAME="$(uv run python - <<'PY'
import os
candidates=[d for d in os.listdir('.') if os.path.isdir(d) and os.path.isfile(os.path.join(d,'__init__.py'))]
print(candidates[0] if candidates else '')
PY
)"
if [[ -z "${PKG_NAME}" ]]; then
  echo "[test] ERROR: No package directory found at project root"
  exit 1
fi
echo "[test] package: ${PKG_NAME}"

echo "[test] import smoke..."
uv run python - <<PY
import importlib
import ${PKG_NAME}, ${PKG_NAME}.main
print("import-ok")
PY

# Clean up empty template-only dirs if any remain
for d in weather_agent hooks scripts; do
  if [[ -d "$d" ]] && [[ -z "$(ls -A "$d" 2>/dev/null)" ]]; then rmdir "$d"; fi
done

echo "[test] console script quick run..."
if command -v timeout >/dev/null 2>&1; then
  timeout 3s uv run "${PROJECT_SLUG}" || true
else
  uv run "${PROJECT_SLUG}" || true
fi

echo "[test] SUCCESS: Template smoke test passed. Output at: ${OUT_DIR}"
