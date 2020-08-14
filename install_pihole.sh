#!/bin/bash

set -e

curl -sSL https://install.pi-hole.net | bash
grep "server\.port.*=" /etc/lighttpd/lighttpd.conf

