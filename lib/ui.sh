#!/usr/bin/env bash

ui_init() {
  local color_enabled="${COLOR:-true}"
  if [[ -t 1 && "${NO_COLOR:-0}" != "1" && "$color_enabled" != "false" ]]; then
    C_RESET='\033[0m'; C_BOLD='\033[1m'; C_DIM='\033[2m'
    C_CYAN='\033[36m'; C_BLUE='\033[34m'; C_GREEN='\033[32m'
    C_YELLOW='\033[33m'; C_RED='\033[31m'; C_WHITE='\033[97m'
  else
    C_RESET=''; C_BOLD=''; C_DIM=''; C_CYAN=''; C_BLUE=''
    C_GREEN=''; C_YELLOW=''; C_RED=''; C_WHITE=''
  fi
}

ui_rule() { printf '%b\n' "${C_BLUE}============================================================${C_RESET}"; }

ui_header() {
  local version="$1"
  ui_rule
  printf '%b\n' "${C_CYAN}${C_BOLD}                  M3rsana v${version}${C_RESET}"
  printf '%b\n' "${C_BLUE}             Your Ubuntu Server, Simplified.${C_RESET}"
  ui_rule
}

ui_section() { printf '\n%b\n' "${C_BOLD}${C_WHITE}$*${C_RESET}"; }
ui_info() { printf '%b\n' "${C_CYAN}[INFO]${C_RESET} $*"; }
ui_ok() { printf '%b\n' "${C_GREEN}[ OK ]${C_RESET} $*"; }
ui_warn() { printf '%b\n' "${C_YELLOW}[WARN]${C_RESET} $*"; }
ui_error() { printf '%b\n' "${C_RED}[FAIL]${C_RESET} $*" >&2; }
ui_muted() { printf '%b\n' "${C_DIM}$*${C_RESET}"; }

ui_confirm() {
  local prompt="${1:-Continue?}" answer
  printf '%b' "${C_YELLOW}${prompt} [y/N]: ${C_RESET}"
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

ui_kv() {
  printf ' %-12s : %s\n' "$1" "$2"
}
