#!/usr/bin/env bash

m3rsana_error_handler() {
  local exit_code=$? line_no="${1:-?}" command="${2:-unknown}"
  log_error "Unhandled error at line ${line_no}: ${command} (exit ${exit_code})"
  ui_error "An unexpected error occurred. Check ${M3RSANA_LOG_FILE}."
  return "$exit_code"
}
