#!/bin/sh
# rsync wrapper that sets configs based on environment variables
# Adapted from https://github.com/axiom-data-science/rsync-server/blob/master/entrypoint.sh

set -e;
USERNAME=${USERNAME:-user}
PASSWORD=${PASSWORD:-pass}
ALLOW=${ALLOW:-192.168.8.0/24 192.168.24.0/24 172.16.0.0/12 127.0.0.1/32}
VOLUME=${VOLUME:-data}

# Setup rsync config files
echo "$USERNAME:$PASSWORD" > /etc/rsyncd.secrets;
chmod 0400 /etc/rsyncd.secrets;
cat > /etc/rsyncd.conf <<EOF
pid file = /var/run/rsyncd.pid
log file = /dev/stdout
timeout = 300
max connections = 10
port = 873

[${VOLUME}]
	uid = root
	gid = root
	fake super = true
	hosts deny = *
	hosts allow = ${ALLOW}
	read only = false
	path = /data
	comment = ${VOLUME} directory
	auth users = ${USERNAME}
	secrets file = /etc/rsyncd.secrets
EOF

# generate host key, for sshing in
ssh-keygen -A;
# generate user key, for sshing out
if [ ! -f /root/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -N "" -q;
fi
echo ======================
cat /root/.ssh/*.pub
echo ======================
if [ "$AUTHORIZED_KEYS" ]; then
  echo -e "$AUTHORIZED_KEYS" > "/root/.ssh/authorized_keys";
fi
# ensure proper permissions of authorized keyys
if [ -f "/root/.ssh/authorized_keys" ]; then
  chown root:root /root/.ssh/authorized_keys;
  chmod 600 /root/.ssh/authorized_keys;
else
  echo "WARNING! no authorized_keys";
fi

exec "$@";
