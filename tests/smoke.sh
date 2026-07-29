#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"$ROOT/m3rsana" version | grep -q '0.1.1-dev'
"$ROOT/m3rsana" help | grep -q 'List loaded modules'
"$ROOT/m3rsana" modules | grep -q 'dashboard'
echo "Smoke tests passed."
