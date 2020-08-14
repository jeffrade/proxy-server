#!/bin/bash
# Usage: Run this script in the background.
# Assumes AWS_HOST_NAME is set (e.g. proxy.example.com)
# Assumes AWS_HOSTED_ZONE_ID is set. 
# Log file can be found at /var/tmp/r53-record.log

NOTIFY_DIR=/var/tmp
LOG_FILE=${NOTIFY_DIR}/r53-record.log
CURR_IP_FILE=${NOTIFY_DIR}/ip.out
TMP_IP_FILE=${NOTIFY_DIR}/ip.tmp
IP_LKP_URL=https://ifconfig.me/ip
RECORD_SET_FILE=${NOTIFY_DIR}/r53-record-set.json
RECORD_SET_NAME="${AWS_HOST_NAME}."
RECORD_SET_TTL=300
HOSTED_ZONE_ID=${AWS_HOSTED_ZONE_ID}

function create_record_json {
	cat << EOF > ${RECORD_SET_FILE}
{
 "Changes": [
  {
   "Action": "UPSERT",
   "ResourceRecordSet": {
    "Name": "${RECORD_SET_NAME}",
    "Type": "A",
    "TTL": ${RECORD_SET_TTL},
    "ResourceRecords": [
     {
      "Value": "${1}"
     }
    ]
   }
  }
 ]
}
EOF
}

function update_route53_record {
	local new_ip=$(cat ${CURR_IP_FILE})
	create_record_json "${new_ip}"
	local resp=$(aws route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE_ID} --change-batch file://${RECORD_SET_FILE})
	echo "Updated route53 record:" >> ${LOG_FILE}
	echo "${resp}" >> ${LOG_FILE}
}

echo "Executing update_dns_record script..." >> ${LOG_FILE}

if [[ ! -f ${RECORD_SET_FILE} ]]; then
	echo "Creating AWS record json..." >> ${LOG_FILE}
	curl -sf $IP_LKP_URL > $CURR_IP_FILE
	create_record_json "$(cat ${CURR_IP_FILE})"
fi

printf $(curl -sf $IP_LKP_URL) > $TMP_IP_FILE
IP_DIFF=$(diff -w $TMP_IP_FILE $CURR_IP_FILE)
if [[ "$IP_DIFF" != "" ]]; then
	echo "We have a new IP: $(cat $TMP_IP_FILE)" >> ${LOG_FILE}
	cat $TMP_IP_FILE > $CURR_IP_FILE
	update_route53_record
fi
