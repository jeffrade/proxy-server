#!/bin/bash

set -e

_HOME_=${HOME}
_PWD_=$(pwd)

cat <<EOF >upload_files_to_s3
# Upload queued files to AWS S3
*/10 * * * * root . ${_HOME_}/.profile && ${_PWD_}/upload_files_to_s3.sh
EOF

sudo chown root:root upload_files_to_s3
sudo chmod 644 upload_files_to_s3
sudo mv upload_files_to_s3 /etc/cron.d/.
