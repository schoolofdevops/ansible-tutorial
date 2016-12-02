#!/bin/bash
DEFAULT_PASS=$(grep "temporary password" /var/log/mysqld.log  | cut -d "@" -f2 | cut -d ":" -f2 | sed -e 's/^[[:space:]]*//')
echo $DEFAULT_PASS
