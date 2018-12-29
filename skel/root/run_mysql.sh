#!/bin/bash

source /root/docker-setup.env

trap "{ echo Stopping MySQLdb Server..; mysqladmin -p${MYSQL_ROOT_PASSWORD} shutdown; exit 0; }" EXIT

echo "Starting MySQLdb Server.."
if [ "x$DATABASE" == "x" ]; then
    dbdir="/opt/Database/mysql"
else
    dbdir="/opt/Database/mysql-${DATABASE}"
fi

if [ -e /opt/mysql ]; then
    rm /opt/mysql
fi
ln -sv $dbdir /opt/mysql

ARGS="--datadir=${dbdir}/data --pid-file=/var/run/mysqld/mysqld.pid"
/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/bin/mysqld_safe $ARGS

