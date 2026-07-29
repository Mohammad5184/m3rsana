#!/usr/bin/env bash

module_register cleanup

module_cleanup_preview() {
  require_root || return 1
  ui_section "Cleanup Preview"
  ui_info "No files will be deleted in preview mode."
  printf '\n'
  journalctl --disk-usage 2>/dev/null || true
  du -sh /var/cache/apt 2>/dev/null || true
  du -sh /var/lib/apt/lists 2>/dev/null || true
  du -sh /var/tmp /tmp 2>/dev/null || true
  log_info "Cleanup preview completed"
}

module_cleanup() {
  require_root || return 1
  ui_section "Cleanup Module"
  ui_warn "Destructive cleanup remains disabled in v${M3RSANA_VERSION}."
  ui_info "Use 'm3rsana cleanup --dry-run' to inspect reclaimable space."
  log_warn "Cleanup invoked while destructive engine is disabled"
}
