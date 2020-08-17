#!/bin/bash
# Usage: Run this script via cron (see install_s3_uploader.sh).
# Assumes S3_BUCKET_NAME is set (e.g. proxy.example.com)
# Log file can be found at /var/tmp/s3-updater.log

set -e

NOTIFY_DIR=/var/tmp
LOG_FILE=${NOTIFY_DIR}/s3-updater.log
QUEUE_DIR=${NOTIFY_DIR}/queue
COMPLETED_DIR=${NOTIFY_DIR}/completed
OLDEST_FILENAME=""

if [[ ! -d "$QUEUE_DIR" || ! -d "$COMPLETED_DIR" ]]; then
  mkdir -p $QUEUE_DIR
  mkdir -p $COMPLETED_DIR
fi

echo "Executing upload_files_to_s3 script. Finding oldest file..." >> ${LOG_FILE}
OLDEST_FILENAME="$(find $QUEUE_DIR -type f -printf '%T+ %p\n' | sort | head -n 1 | grep -o " .*")"

if [[ -n "$OLDEST_FILENAME" ]] ; then
  echo "Found $OLDEST_FILENAME. Waiting 60 seconds in case data being transferred..." >> ${LOG_FILE}
  sleep 60s
  echo "Uploading $OLDEST_FILENAME to S3..." >> ${LOG_FILE}
  aws s3 cp --storage-class=STANDARD --force-glacier-transfer --only-show-errors $OLDEST_FILENAME s3://$S3_BUCKET_NAME
  echo "Done Uploading. Moving to $COMPLETED_DIR..." >> ${LOG_FILE}
  mv $OLDEST_FILENAME $COMPLETED_DIR
fi