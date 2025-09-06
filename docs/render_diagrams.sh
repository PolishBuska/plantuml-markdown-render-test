#!/usr/bin/env bash
set -euo pipefail

# In-place render of all PlantUML diagrams under docs/diagrams to PNGs
# Output files are created next to the source .puml files.
# Requirements: plantuml (and graphviz 'dot' for certain diagram types).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SCRIPT_DIR}/diagrams"

if ! command -v plantuml >/dev/null 2>&1; then
  echo "Error: plantuml is not installed or not in PATH." >&2
  echo "Install via: brew install plantuml graphviz (macOS) or apt/yum on Linux." >&2
  exit 1
fi

# Render PNGs in place
find "${SRC_DIR}" -type f -name "*.puml" -print0 | \
  xargs -0 -I {} plantuml -tpng "{}"

echo "Rendered diagrams (PNG) next to sources in ${SRC_DIR}"
