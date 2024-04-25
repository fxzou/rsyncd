#!/bin/sh

sh /scripts/init.sh
crond
tail -f /log/sync.log