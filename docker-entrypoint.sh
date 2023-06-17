#!/bin/bash
set -e

mkdir -p /data/Baza
chmod 700 /data/Baza

# First argument is a flag, assuming user wants to run bazad
if [ "${1:0:1}" = '-' ]; then
	set -- bazad -c /etc/baza/config.json "$@"
fi

# Change file ownership to baza if running as root
# and drop privilege to baza
if [ "$1" = 'bazad' -a "$(id -u)" = '0' ]; then
	find /data \! -user baza -exec chown baza '{}' +
	exec gosu baza "$@"
fi

exec "$@"
