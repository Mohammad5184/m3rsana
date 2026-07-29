#!/usr/bin/env bash

module_register about

module_about() {
  ui_section "About M3rsana"
  printf ' M3rsana is an open-source Ubuntu server administration toolkit.\n'
  printf ' Version : %s\n' "$M3RSANA_VERSION"
  printf ' License : MIT\n'
  printf ' Tagline : Your Ubuntu Server, Simplified.\n'
}
