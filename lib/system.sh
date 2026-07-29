#!/usr/bin/env bash

require_root() {
  if [[ $EUID -ne 0 ]]; then
    ui_error "This command must be run as root."
    return 1
  fi
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

system_os_name() {
  if [[ -r /etc/os-release ]]; then
    local PRETTY_NAME=""
    # shellcheck disable=SC1091
    . /etc/os-release
    printf '%s' "${PRETTY_NAME:-Unknown Linux}"
  else
    printf 'Unknown Linux'
  fi
}

system_cpu_model() {
  local model
  model="$(awk -F: '/model name/ {
    sub(/^[ \t]+/, "", $2)
    print $2
    exit
  }' /proc/cpuinfo 2>/dev/null || true)"

  printf '%s' "${model:-Unknown}"
}

system_cpu_count() {
  if command_exists nproc; then
    nproc
  else
    grep -c '^processor' /proc/cpuinfo 2>/dev/null || printf '0'
  fi
}

system_load_1m() {
  awk '{print $1}' /proc/loadavg 2>/dev/null || printf '0'
}

system_load_status() {
  local load cpu_count

  load="$(system_load_1m)"
  cpu_count="$(system_cpu_count)"

  awk -v load="$load" -v cpu="$cpu_count" '
    BEGIN {
      if (cpu <= 0) {
        print "unknown"
      } else if (load < cpu * 0.70) {
        print "normal"
      } else if (load < cpu) {
        print "moderate"
      } else {
        print "high"
      }
    }
  '
}

system_disk_usage() {
  df -P / | awk 'NR == 2 {
    gsub("%", "", $5)
    print $5
  }'
}

system_disk_human() {
  df -hP / | awk 'NR == 2 {
    print $3 " / " $2 " (" $5 ")"
  }'
}

system_memory_usage() {
  free | awk '/Mem:/ {
    if ($2 > 0) {
      printf "%.0f", ($3 / $2) * 100
    } else {
      print 0
    }
  }'
}

system_swap_usage() {
  free | awk '/Swap:/ {
    if ($2 <= 0) {
      print "disabled"
    } else {
      printf "%.0f", ($3 / $2) * 100
    }
  }'
}

system_memory_human() {
  free -h | awk '/Mem:/ {
    print $3 " / " $2 " (" sprintf("%.0f", ($3 / $2) * 100) "%)"
  }'
}

system_uptime() {
  uptime -p 2>/dev/null | sed 's/^up //' || true
}

system_ip() {
  hostname -I 2>/dev/null | awk '{print $1}' || true
}

service_is_active() {
  systemctl is-active --quiet "$1" 2>/dev/null
}
