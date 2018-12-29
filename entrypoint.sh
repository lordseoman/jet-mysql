#!/bin/bash

if [ -e /var/run/mysqld/mysqld.pid ]; then
   echo "Unsafe shutdown..."
fi

if [ ! -e /.docker-setup.1st ]; then
    if [ ! -e /opt/Database/mysql/data/mysql ]; then
        /root/setup.sh
        RET=$?
    else
        RET=0
    fi
    if [ -e /var/log/awslogs-agent-setup.log ]; then
        cat /var/log/awslogs-agent-setup.log
    fi
    touch /.docker-setup.1st
else
    RET=0
fi

if [ $RET -eq 0 ]; then
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
else
    echo "MySQL setup failed, starting bash instead of supervisor.."
    cat /root/mysql.setup.log
    if [ -e /opt/Database/mysql/logs/mysql.err ]; then
        cat /opt/Database/mysql/logs/mysql.err
    fi
    while true; do
        echo "Waiting.."
        sleep 5
    done
fi

