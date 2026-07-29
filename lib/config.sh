#!/usr/bin/env bash

config_apply_defaults() {
  COLOR="${COLOR:-true}"
  LOG_LEVEL="${LOG_LEVEL:-info}"
  AUTO_BACKUP="${AUTO_BACKUP:-true}"
  LOG_RETENTION_DAYS="${LOG_RETENTION_DAYS:-14}"
  JOURNAL_MAX_SIZE="${JOURNAL_MAX_SIZE:-200M}"
  AUTO_UPDATE="${AUTO_UPDATE:-false}"
}

config_valid_key() {
  case "$1" in
    COLOR|LOG_LEVEL|AUTO_BACKUP|LOG_RETENTION_DAYS|JOURNAL_MAX_SIZE|AUTO_UPDATE|M3RSANA_LOG_FILE) return 0 ;;
    *) return 1 ;;
  esac
}

config_load_file() {
  local file="$1" line key value
  [[ -r "$file" ]] || return 0
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line%%#*}"
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue
    if [[ "$line" =~ ^[[:space:]]*([A-Z0-9_]+)[[:space:]]*=[[:space:]]*(.*)[[:space:]]*$ ]]; then
      key="${BASH_REMATCH[1]}"
      value="${BASH_REMATCH[2]}"
      value="${value%\"}"; value="${value#\"}"
      value="${value%\'}"; value="${value#\'}"
      if config_valid_key "$key"; then
        printf -v "$key" '%s' "$value"
        export "${key?}"
      fi
    fi
  done < "$file"
}

load_config() {
  config_apply_defaults
  config_load_file "$M3RSANA_ROOT/config/default.conf"
  config_load_file "/etc/m3rsana.conf"
  config_apply_defaults
}
