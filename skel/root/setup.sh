#!/bin/bash

echo "Setting permissions.."

source /root/docker-setup.env

sql << EOF
GRANT ALL ON *.* TO '${MYSQL_JET_USERNAME}'@'localhost' IDENTIFIED BY '${MYSQL_JET_PASSWORD}';
GRANT ALL ON *.* TO '${MYSQL_JET_USERNAME}'@'127.0.0.1';
GRANT ALL ON *.* TO '${MYSQL_JET_USERNAME}'@'${MYSQL_NETWORK}';
GRANT SHOW DATABASES ON *.* TO 'jetdb'@'localhost';
GRANT SHOW DATABASES ON *.* TO 'jetdb'@'127.0.0.1';
GRANT SHOW DATABASES ON *.* TO 'jetdb'@'${MYSQL_NETWORK}';
FLUSH PRIVILEGES;
EOF

mysql -uroot -e "${sql}"

mysqladmin -uroot password "${MYSQL_ROOT_PASSWORD}"

rm /root/docker-setup.env
touch /.docker-setup.cf

