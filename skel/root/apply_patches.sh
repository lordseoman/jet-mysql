#!/bin/bash

cd /

if [ -e /root/patches ]; then
    for file in `ls -c1 /root/patches/*`; do
        patch -p0 --forward -i $file
    done
fi
