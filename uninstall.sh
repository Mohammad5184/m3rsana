#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run this uninstaller as root." >&2
  exit 1
fi

rm -f /usr/local/bin/m3rsana
rm -rf /opt/m3rsana
printf 'M3rsana was removed. Configuration and logs were preserved.\n'
