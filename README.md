# proxy-server

## About

Initialization scripts for setting up a Linux machine as a DIY proxy server.

## Install

```
$ git clone https://github.com/jeffrade/proxy-server.git
$ cd proxy-server
$ bash install.sh
```
Note: There are a series of prompts, so you'll have to sit through the installation. nginx configuration will need to be manually updated with your domain (hard-coded to example.com).

## What does this do?

 - Installs fail2ban
 - Installs pi-hole
 - Installs nginx
 - Installs [certbot](https://certbot.eff.org/about/) for TLS/SSL [Let's Encrypt](https://letsencrypt.org/getting-started/) certificates
 - Installs AWS Route53 DNS updater [TODO]
 - Installs AWS S3 Glacier uploader [TODO]

## Troubleshooting
 - If installing pihole alongside nginx, it is strongly recommended to change the pihole `server.port` to something other than `80`.
 - Feel free to open an [issue](https://github.com/jeffrade/proxy-server/issues/new).
 - Pull Requests welcomed.
