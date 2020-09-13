#!/bin/bash

# You must first make changes to /etc/postgresql/11/main/postgresql.conf
# archive_command = 'test ! -f /var/lib/postgresql/11/backup/wal/%f && cp %p /var/lib/postgresql/11/backup/wal/%f'
# wal_level = replica/hot_standby
# archive_mode = on
# and execute systemctl restart postgresql@11-main
# crontab - 00 01 * * * postgres /var/lib/postgresql/postgres-backup.bat

# This script must be run under POSTGRES USER
# Variable initialization
PG_DIR="/var/lib/postgresql/11"
PG_MAIN_DIR="$PG_DIR/main"
PG_BACKUP_DIR="$PG_DIR/backup"
PG_FULL_BACKUP_DIR="$PG_BACKUP_DIR/full-recovery"
PG_PIT_BACKUP_DIR="$PG_BACKUP_DIR/pit-recovery"
PG_WAL_BACKUP_DIR="$PG_BACKUP_DIR/wal"
#DATE="/bin/date"
#DATE_TIME_DIR=`$DATE +%Y-%m-%d_%H-%M-%S`
PG_PITR_BACKUP_FILE="postgresql-pitr.tar.gz"

# Check the existence of directories full-recovery
if [ ! -d $PG_FULL_BACKUP_DIR ]; then
    mkdir -p $PG_FULL_BACKUP_DIR
    echo "Directory $PG_FULL_BACKUP_DIR created successfully"
fi

# Check the existence of directories pit-recovery
if [ ! -d $PG_PIT_BACKUP_DIR ]; then
    mkdir -p $PG_PIT_BACKUP_DIR
    echo "Directory $PG_PIT_BACKUP_DIR created successfully"
fi

# Check the existence of directories wal
if [ ! -d $PG_WAL_BACKUP_DIR ]; then
    mkdir -p $PG_WAL_BACKUP_DIR
    echo "Directory $PG_WAL_BACKUP_DIR created successfully"
fi

# File existence check
if [ -f $PG_MAIN_DIR/backup_label ]; then
    rm -rf $PG_MAIN_DIR/backup_label
fi

if [ -f $PG_MAIN_DIR/recovery.conf ]; then
    rm -rf $PG_MAIN_DIR/recovery.conf
fi

########## Creating a FULL Backup ##########
echo "--------------------"
echo "Creating a FULL Backup"
rm -rf $PG_FULL_BACKUP_DIR/*
pg_basebackup -Ft -D $PG_FULL_BACKUP_DIR
if [ -f $PG_FULL_BACKUP_DIR/base.tar ]; then
    echo "FULL Backup created successfully"
fi

########## Creating a PITR Backup ##########
echo "--------------------"
echo "Creating a PITR Backup"
rm -rf $PG_PIT_BACKUP_DIR/PG_PITR_BACKUP_FILE
rm -rf $PG_WAL_BACKUP_DIR/*
pg_basebackup -Ft -X none -D - | gzip > $PG_PIT_BACKUP_DIR/$PG_PITR_BACKUP_FILE
if [ -f $PG_PIT_BACKUP_DIR/$PG_PITR_BACKUP_FILE ]; then
    echo "PITR Backup created successfully"
fi
echo "--------------------"

# make changes to the base

exit