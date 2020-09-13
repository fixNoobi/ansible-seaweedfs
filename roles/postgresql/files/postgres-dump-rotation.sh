#/bin/bash

# crontab - 00 11 * * * /var/lib/postgresql/postgres-dump-rotation.sh >> /var/lib/postgresql/11/backup/log/postgres-dump-rotation.log
find /var/lib/postgresql/11/backup/dump/* -type f -mtime +20 -delete
