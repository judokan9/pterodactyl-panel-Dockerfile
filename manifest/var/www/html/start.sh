#!/bin/ash
set -e

echo "setting up services"

if [ "$1" = "/sbin/tini" ]; then
    if [ "$ssl" == "false" ]; then
        echo "disabling ssl support" 
        sed -i "s,https://,http://,g" /etc/caddy/caddy.conf
        sed -i "s,<domain>,$panel_url,g" /etc/caddy/caddy.conf
        sed -i "s,<email>,off,g" /etc/caddy/caddy.conf
    else
        echo "configuring ssl support"
        sed -i "s,<domain>,$panel_url,g" /etc/caddy/caddy.conf
        sed -i "s,<email>,$admin_email,g" /etc/caddy/caddy.conf
    fi
fi

echo "continuing startup"

exec "$@"
