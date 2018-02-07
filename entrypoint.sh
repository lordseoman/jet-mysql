#!/bin/bash

if [ -e /var/run/mysqld/mysqld.pid ]; then
   echo "Unsafe shutdown..."
fi

/usr/bin/mysqld_safe

