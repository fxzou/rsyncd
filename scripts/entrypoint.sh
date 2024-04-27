#!/bin/sh

sh /scripts/init.sh
crond
tail -f /log/backup.log