#!/bin/bash

if [ ! -e /root/docker-setup.env ]; then
    echo "First run of MySQL, setting up default db.."
    if [ ! -e /opt/Database/mysql ]; then
        mkdir -p /opt/Database/mysql/data
        mkdir -p /opt/Database/mysql/logs
        mkdir -p /opt/Database/mysql/binlogs
    fi
    chown mysql:mysql -R /opt/Database/mysql
    mysql_install_db --user=mysql
fi

if [ -e /var/run/mysqld/mysqld.pid ]; then
   echo "Unsafe shutdown..."
fi

/usr/bin/supervisord

if [ -e /root/docker-setup.env ]; then
    /root/setup.sh
fi
