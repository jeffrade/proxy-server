#!/bin/bash

echo "Starting..."

apt-get update
apt-get install -y fail2ban

systemctl start fail2ban
systemctl enable fail2ban

cat <<EOF >/etc/fail2ban/jail.local
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF

systemctl restart fail2ban

rm -rf $HOME/.ssh
mkdir $HOME/.ssh && echo "" >> $HOME/.ssh/authorized_keys
chmod go-w $HOME $HOME/.ssh
chmod 600 $HOME/.ssh/authorized_keys
chown `whoami` $HOME/.ssh/authorized_keys

# Use ssh-copy-id to add .ssh/id_rsa.pub from client machine to remote server  https://linux.die.net/man/1/ssh-copy-id 

echo "Done!"
