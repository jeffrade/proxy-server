#!/bin/bash

set -e

BLUE='\033[94m'
GREEN='\033[32;1m'
RED='\033[91;1m'
RESET='\033[0m'
_PWD_=$(pwd)
_HOME_=${HOME}

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
  curl -sSL https://install.pi-hole.net | bash
  grep "server\.port.*=" /etc/lighttpd/lighttpd.conf
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
  chmod 555 update_dns_record.sh
  cat <<EOF >update_dns_record
# Check if IP change and update DNS record
source ${_HOME_}/.profile
*/5 * * * * ${_PWD_}/update_dns_record.sh
EOF
  sudo chown root:root update_dns_record
  sudo chmod 644 update_dns_record
  sudo mv update_dns_record /etc/cron.d/.
fi

print_success "Installation complete!"
