#!/usr/bin/env bash

M3RSANA_LOG_FILE="${M3RSANA_LOG_FILE:-/var/log/m3rsana.log}"

log_level_number() {
  case "${1,,}" in
    debug) printf '10' ;;
    info)  printf '20' ;;
    warn)  printf '30' ;;
    error) printf '40' ;;
    *)     printf '20' ;;
  esac
}

log_message() {
  local level="${1:-INFO}"; shift || true
  local configured current line
  configured="$(log_level_number "${LOG_LEVEL:-info}")"
  current="$(log_level_number "$level")"
  (( current < configured )) && return 0

  line="$(date '+%Y-%m-%d %H:%M:%S') [${level^^}] $*"
  if [[ $EUID -eq 0 ]]; then
    mkdir -p "$(dirname "$M3RSANA_LOG_FILE")"
    printf '%s\n' "$line" >> "$M3RSANA_LOG_FILE"
  elif [[ -w "$(dirname "$M3RSANA_LOG_FILE")" ]]; then
    printf '%s\n' "$line" >> "$M3RSANA_LOG_FILE"
  fi
}

log_debug() { log_message DEBUG "$@"; }
log_info()  { log_message INFO "$@"; }
log_warn()  { log_message WARN "$@"; }
log_error() { log_message ERROR "$@"; }
