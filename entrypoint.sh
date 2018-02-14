#!/bin/bash

sleep infinity & PID=$!
trap "kill $PID" INT TERM

if [ -e /var/run/mysqld/mysqld.pid ]; then
   echo "Unsafe shutdown..."
fi

if [ ! -e /opt/Database/mysql ]; then 
    echo "First run setup."
	echo
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
	SERVERNAME=`echo "$SERVERNAME" | tr '[:upper:]' '[:lower:]'`
	read -d '' QUERY <<- EOM
		update user set password=PASSWORD('$DB_PASSWORD') where user='root';
		update user set host='$FQDN' where user='root' and host='$SERVERNAME';
		flush privileges;
	EOM
    /usr/bin/mysqladmin -u root password "$DB_PASSWORD"
	/usr/bin/mysql --batch --password="$DB_PASSWORD" --database="mysql" -e "$QUERY"
	echo
	echo "Setup complete.."
else
    /usr/bin/mysqld_safe &
fi
wait
echo "Goodbye.."
