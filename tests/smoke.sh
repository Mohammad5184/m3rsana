#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bash "$ROOT/m3rsana" version | grep -q '0.1.1-dev'
bash "$ROOT/m3rsana" help | grep -q 'List loaded modules'
bash "$ROOT/m3rsana" modules | grep -q 'dashboard'
echo "Smoke tests passed."
