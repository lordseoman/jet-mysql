#!/bin/bash

IP=$1
MACHINE=$2

sleep infinity & PID=$!
trap "kill $PID" INT TERM

if [ -e /var/run/mysqld/mysqld.pid ]; then
   echo "Unsafe shutdown..."
fi

if [ ! -e /opt/Database/mysql ]; then 
    echo "First run setup."
    mkdir -p /opt/Database/mysql/data
    mkdir -p /opt/Database/mysql/binlogs
    mkdir -p /opt/Database/mysql/logs
    mkdir -p /opt/Database/mysql/tmp
    touch /opt/Database/mysql/logs/mysql.err
    chown -R mysql:mysql /opt/Database/mysql
    /usr/bin/mysql_install_db --user=mysql
    /usr/bin/mysqld_safe &
    sleep 2
    echo -n "Enter the administrator password: "
    read DB_PASSWORD
    echo $DB_PASSWORD $IP $MACHINE
    /usr/bin/mysqladmin -u root password '${DB_PASSWORD}'
    #/usr/bin/mysqladmin -u root -h ${IP} password '${DB_PASSWORD}'
    #/usr/bin/mysqladmin -u root -h ${MACHINE} password '${DB_PASSWORD}'
    #/bin/bash
else
    /usr/bin/mysqld_safe &
fi
wait
echo "Goodbye.."
