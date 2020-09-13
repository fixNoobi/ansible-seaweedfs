#!/bin/bash -x

# This script must be run under ROOT USER
# Varible initialization
PG_DIR="/var/lib/postgresql/11"
PG_MAIN_DIR="$PG_DIR/main"
PG_BACKUP_DIR="$PG_DIR/backup"
PG_FULL_BACKUP_DIR="$PG_BACKUP_DIR/full-recovery"

# Check under what user the script is started
if [ `whoami` != 'root' ]; then
  echo "Please run the script under user root"
  exit 1
fi

# FULL Backup existence check
if [ -f $PG_FULL_BACKUP_DIR/base.tar ]; then
    echo "--------------------"
    echo "Restore FULL Backup"
else
    echo "FULL Backup is not created"
    exit 1
fi

# Stop Database cluster
systemctl stop postgresql@11-main

# Destroy Database
cd $PG_DIR
rm -rf main/*

# FULL Database recovery
tar -xvf $PG_FULL_BACKUP_DIR/base.tar -C $PG_MAIN_DIR
tar -xvf $PG_FULL_BACKUP_DIR/pg_wal.tar -C $PG_MAIN_DIR/pg_wal

# Start Database cluster
systemctl start postgresql@11-main

# Restart Database
systemctl restart postgresql@11-main

exit 0
