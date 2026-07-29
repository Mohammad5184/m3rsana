#!/usr/bin/env bash

module_register health

module_health() {
  local score=100 disk memory
  disk="$(system_disk_usage)"; memory="$(system_memory_usage)"
  ui_section "Health Check"

  if (( disk >= 90 )); then ui_error "Root filesystem is critical: ${disk}%"; score=$((score-30))
  elif (( disk >= 80 )); then ui_warn "Root filesystem is high: ${disk}%"; score=$((score-15))
  else ui_ok "Root filesystem usage: ${disk}%"; fi

  if (( memory >= 90 )); then ui_error "Memory usage is critical: ${memory}%"; score=$((score-25))
  elif (( memory >= 80 )); then ui_warn "Memory usage is high: ${memory}%"; score=$((score-10))
  else ui_ok "Memory usage: ${memory}%"; fi

  if service_is_active ssh || service_is_active sshd; then ui_ok "SSH service is running"; else ui_warn "SSH service status not confirmed"; score=$((score-10)); fi
  if service_is_active systemd-journald; then ui_ok "Journal service is running"; else ui_warn "Journal service status not confirmed"; score=$((score-10)); fi

  (( score < 0 )) && score=0
  printf '\n%b\n' "${C_BOLD}Health Score: ${score}/100${C_RESET}"
  log_info "Health check completed with score ${score}/100"
}
