#!/usr/bin/env bash

module_register health

module_health() {
  local score=100
  local disk memory swap load_status

  disk="$(system_disk_usage)"
  memory="$(system_memory_usage)"
  swap="$(system_swap_usage)"
  load_status="$(system_load_status)"

  ui_section "Health Check"

  if (( disk >= 90 )); then
    ui_error "Root filesystem is critical: ${disk}%"
    score=$((score - 30))
  elif (( disk >= 80 )); then
    ui_warn "Root filesystem is high: ${disk}%"
    score=$((score - 15))
  else
    ui_ok "Root filesystem usage: ${disk}%"
  fi

  if (( memory >= 90 )); then
    ui_error "Memory usage is critical: ${memory}%"
    score=$((score - 25))
  elif (( memory >= 80 )); then
    ui_warn "Memory usage is high: ${memory}%"
    score=$((score - 10))
  else
    ui_ok "Memory usage: ${memory}%"
  fi

  case "$load_status" in
    normal)
      ui_ok "CPU load is normal"
      ;;
    moderate)
      ui_warn "CPU load is moderate"
      score=$((score - 10))
      ;;
    high)
      ui_error "CPU load is high"
      score=$((score - 20))
      ;;
    *)
      ui_warn "CPU load status could not be determined"
      score=$((score - 5))
      ;;
  esac

  if [[ "$swap" == "disabled" ]]; then
    ui_warn "Swap is not configured"
    score=$((score - 5))
  elif (( swap >= 90 )); then
    ui_error "Swap usage is critical: ${swap}%"
    score=$((score - 10))
  elif (( swap >= 75 )); then
    ui_warn "Swap usage is high: ${swap}%"
    score=$((score - 5))
  else
    ui_ok "Swap usage: ${swap}%"
  fi

  if service_is_active ssh || service_is_active sshd; then
    ui_ok "SSH service is running"
  else
    ui_warn "SSH service status not confirmed"
    score=$((score - 10))
  fi

  if service_is_active systemd-journald; then
    ui_ok "Journal service is running"
  else
    ui_warn "Journal service status not confirmed"
    score=$((score - 10))
  fi

  (( score < 0 )) && score=0

  printf '\n%b\n' "${C_BOLD}Health Score: ${score}/100${C_RESET}"
  log_info "Health check completed with score ${score}/100"
}
