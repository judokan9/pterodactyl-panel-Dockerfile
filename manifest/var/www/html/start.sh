#!/bin/ash

set -e

if [ "$1" = 'tini' ]; then
    if [ "$ssl" == "false" ]; then
        sed -i "s,https://,http://,g" /etc/caddy/caddy.conf
        sed -i "s,<domain>,$panel_url,g" /etc/caddy/caddy.conf
        sed -i "s,<email>,off,g" /etc/caddy/caddy.conf
    else
        sed -i "s,<domain>,$panel_url,g" /etc/caddy/caddy.conf
        sed -i "s,<email>,$admin_email,g" /etc/caddy/caddy.conf
    fi
fi

exec "$@"
