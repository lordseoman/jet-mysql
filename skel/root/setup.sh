#!/bin/bash

echo "First run of MySQL, setting up default db.."

source /root/docker-setup.env
source /root/defaults

mkdir -p /opt/Database/mysql/data
mkdir -p /opt/Database/mysql/logs
mkdir -p /opt/Database/mysql/binlogs
chown mysql:mysql -R /opt/Database/mysql

echo "Installing initial database.."
mysql_install_db --user=mysql

sql=$(cat <<EOF
GRANT ALL ON *.* TO '${MYSQL_JET_USERNAME}'@'localhost' IDENTIFIED BY '${MYSQL_JET_PASSWORD}';
GRANT ALL ON *.* TO '${MYSQL_JET_USERNAME}'@'127.0.0.1' IDENTIFIED BY '${MYSQL_JET_PASSWORD}';
GRANT ALL ON *.* TO '${MYSQL_JET_USERNAME}'@'${IP}/24' IDENTIFIED BY '${MYSQL_JET_PASSWORD}';
GRANT ALL ON *.* TO '${MYSQL_JET_USERNAME}'@'${MACHINE}' IDENTIFIED BY '${MYSQL_JET_PASSWORD}';
GRANT SHOW DATABASES ON *.* TO 'jetdb'@'localhost';
GRANT SHOW DATABASES ON *.* TO 'jetdb'@'127.0.0.1';
GRANT SHOW DATABASES ON *.* TO 'jetdb'@'${IP}/24';
GRANT SHOW DATABASES ON *.* TO 'jetdb'@'${MACHINE}';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
SET PASSWORD FOR 'root'@'${MACHINE}' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
EOF
)

nohup /usr/bin/mysqld_safe --pid-file=/var/run/mysqld/mysqld.pid > /root/mysql.setup.log 2>&1 &
pid=$!

echo -n "Waiting for MySQL to start "
maxcounter=60
counter=1
while ! mysql -uroot -e "show databases;" > /dev/null 2>&1; do
    sleep 1
    counter=`expr $counter + 1`
    if [ $counter -gt $maxcounter ]; then
        echo "FAILED"
        exit 1
    fi;
    echo -n "."
done
echo "  OK"

echo "Setting permissions for jetdb.."
mysql -uroot -e "${sql}"
mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

rm /root/docker-setup.env
touch /.docker-setup.cf
echo "Setup complete."

