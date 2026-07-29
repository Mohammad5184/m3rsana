#!/usr/bin/env bash

module_register dashboard

module_dashboard() {
  local host os kernel uptime ip load disk memory
  host="$(hostname)"; os="$(system_os_name)"; kernel="$(uname -r)"
  uptime="$(system_uptime)"; ip="$(system_ip)"; load="$(system_load_1m)"
  disk="$(system_disk_human)"; memory="$(system_memory_human)"

  ui_section "System Overview"
  ui_kv "Hostname" "$host"
  ui_kv "Operating OS" "$os"
  ui_kv "Kernel" "$kernel"
  ui_kv "Uptime" "${uptime:-Unknown}"
  ui_kv "IPv4" "${ip:-Unknown}"
  ui_kv "Load (1m)" "$load"
  ui_kv "Memory" "$memory"
  ui_kv "Disk /" "$disk"

  ui_section "Core Services"
  if service_is_active ssh || service_is_active sshd; then ui_ok "SSH is running"; else ui_warn "SSH status not confirmed"; fi
  if service_is_active systemd-journald; then ui_ok "systemd-journald is running"; else ui_warn "journald status not confirmed"; fi
}
