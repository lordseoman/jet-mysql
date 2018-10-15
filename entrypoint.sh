#!/bin/bash

if [ -e /var/run/mysqld/mysqld.pid ]; then
   echo "Unsafe shutdown..."
fi

if [ -e /root/docker-setup.env ]; then
    /root/setup.sh
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

