#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
while IFS= read -r -d '' file; do bash -n "$file"; done < <(find "$ROOT" -type f \( -name '*.sh' -o -name 'm3rsana' \) -print0)
echo "Syntax checks passed."
