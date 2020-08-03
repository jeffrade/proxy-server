#!/bin/bash

set -e

apt-get update
apt-get install nginx

cat <<EOF > /etc/nginx/conf.d/example.conf
server {
  listen 80;
  listen [::]:80;

  server_name proxy.example.com;

}

server {

    server_name proxy.example.com;

    location /app/ {
      proxy_pass http://localhost:8080/;
    }
}
EOF

nginx -s reload
