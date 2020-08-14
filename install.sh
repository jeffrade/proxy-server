#!/bin/bash

set -e

BLUE='\033[94m'
GREEN='\033[32;1m'
RED='\033[91;1m'
RESET='\033[0m'

print_info() {
    printf "$BLUE$1$RESET\n"
}

print_success() {
    printf "$GREEN$1$RESET\n"
    sleep 1
}

print_error() {
    printf "$RED$1$RESET\n"
    sleep 1
}

print_info "Staring..."

if [[ "${OSTYPE}" != *linux* ]]; then
  print_error "Sorry, at the moment, this script only supports Linux."
  exit 1
fi

print_info "Installing fail2ban..."
sudo bash install_fail2ban.sh

print_info "Installing pi-hole..."
if [[ -z `command -v pihole` ]]; then
  sudo bash install_pihole.sh
  print_info "WARNING: It is recommended to set the pihole server port to something other than 80"
fi

print_info "Installing nginx..."
if [[ -z `command -v nginx` ]]; then
  sudo bash install_nginx.sh
fi

print_info "Installing certbot (assumes nginx)..."
if [[ -z `command -v certbot` ]]; then
  sudo bash install_certbot.sh
fi

print_info "Installing DNS updater (checks for aws)..."
if [[ `command -v aws` ]]; then
  sudo bash install_dns_updater.sh
fi

print_success "Installation complete!"
