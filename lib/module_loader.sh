#!/usr/bin/env bash

M3RSANA_MODULES=()

module_register() {
  local name="$1"
  M3RSANA_MODULES+=("$name")
}

module_load_all() {
  local file
  shopt -s nullglob
  for file in "$M3RSANA_ROOT"/modules/*.sh; do
    # shellcheck disable=SC1090
    . "$file"
  done
  shopt -u nullglob
}

module_exists() {
  declare -F "module_${1}" >/dev/null 2>&1
}

module_run() {
  local name="$1"; shift || true
  if module_exists "$name"; then
    "module_${name}" "$@"
  else
    ui_error "Module not found: $name"
    return 1
  fi
}
