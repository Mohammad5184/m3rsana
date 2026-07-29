#!/usr/bin/env bash
set -Eeuo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run this installer as root." >&2
  exit 1
fi

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/opt/m3rsana"
BIN_LINK="/usr/local/bin/m3rsana"

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cp -a "$SOURCE_DIR/." "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/m3rsana" "$INSTALL_DIR/install.sh" "$INSTALL_DIR/uninstall.sh"
ln -sfn "$INSTALL_DIR/m3rsana" "$BIN_LINK"

if [[ ! -f /etc/m3rsana.conf ]]; then
  cp "$INSTALL_DIR/config/default.conf" /etc/m3rsana.conf
fi

mkdir -p /var/lib/m3rsana
printf 'M3rsana installed successfully.\nRun: m3rsana\n'
