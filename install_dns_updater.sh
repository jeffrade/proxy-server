#!/bin/bash

set -e

_HOME_=${HOME}
_PWD_=$(pwd)

cat <<EOF >update_dns_record
# Check if IP change and update DNS record
source ${_HOME_}/.profile
*/5 * * * * ${_PWD_}/update_dns_record.sh
EOF

sudo chown root:root update_dns_record
sudo chmod 644 update_dns_record
sudo mv update_dns_record /etc/cron.d/.

