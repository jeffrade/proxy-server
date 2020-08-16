# proxy-server

## About

Initialization scripts for setting up a Linux machine as a DIY proxy server. This is still a WIP and not fully automated.

## Install

```
$ aws configure
$ export AWS_HOSTED_ZONE_ID=my-host-id # Substitute your values
$ export AWS_HOST_NAME=proxy.example.me # Substitute your values
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
 - Installs AWS Route53 DNS updater
 - Installs AWS S3 Glacier uploader [TODO]
 - [Dockerize](https://docs.docker.com/engine/install/ubuntu/) this? [TODO]

## Troubleshooting
 - If installing pihole alongside nginx, it is strongly recommended to change the pihole `server.port` to something other than `80` (nginx and certbot installation is known to fail).
 - If you have `aws` installed with keys that can access Route53, export your `AWS_HOSTED_ZONE_ID` and `AWS_HOST_NAME`.
 - Feel free to open an [issue](https://github.com/jeffrade/proxy-server/issues/new).
 - Pull Requests welcomed.
