#!/bin/bash
# For nginx and Ubuntu 18.04
# https://certbot.eff.org/lets-encrypt/ubuntubionic-nginx

set -e

apt-get update
apt-get install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get update

apt-get install certbot python3-certbot-nginx

certbot --nginx

certbot renew --dry-run
# The command to renew certbot is installed in one of the following locations:  
#  /etc/crontab/
#  /etc/cron.*/*
#  systemctl list-timers


