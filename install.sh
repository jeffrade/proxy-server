#!/bin/bash

set -e

BLUE='\033[94m'
GREEN='\033[32;1m'
RED='\033[91;1m'
RESET='\033[0m'

SYSTEM=$(uname -s)

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

if [[ $SYSTEM != "Linux" ]]; then
  print_error "Sorry, at the moment, this script only supports Linux."
  exit 1
fi

print_info "Installing fail2ban..."
sudo bash install_fail2ban.sh

print_info "Installing pi-hole..."
if [[ -z `command -v pihole` ]]; then
  curl -sSL https://install.pi-hole.net | bash
fi

print_info "Installing nginx..."
if [[ -z `command -v nginx` ]]; then
  sudo bash install_nginx.sh
fi

print_info "Installing certbot (assumes nginx)..."
if [[ -z `command -v certbot` ]]; then
  sudo bash install_certbot.sh
fi

print_success "Installation complete!"
