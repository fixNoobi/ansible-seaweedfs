#!/bin/bash -x

# This script must be run under ROOT USER
# If necessary, after running the script, execute SELECT pg_wal_replay_resume();
# Variable initialization
PG_DIR="/var/lib/postgresql/11"
PG_MAIN_DIR="$PG_DIR/main"
PG_BACKUP_DIR="$PG_DIR/backup"
PG_FULL_BACKUP_DIR="$PG_BACKUP_DIR/full-recovery"
PG_PIT_BACKUP_DIR="$PG_BACKUP_DIR/pit-recovery"
PG_WAL_BACKUP_DIR="$PG_BACKUP_DIR/wal"
PG_PITR_BACKUP_FILE="postgresql-pitr.tar.gz"

# Until which time the restoration will be made, data above PG_RECOVERY_TIME will not be restored
PG_RECOVERY_TIME="2019-03-01 07:30:10 MSK"

# Check under what user the script is started
if [ `whoami` != 'root' ]; then
  echo "Please run the script under user root"
  exit 1
fi

# Check the existence of file
if [ ! -f $PG_PIT_BACKUP_DIR/$PG_PITR_BACKUP_FILE ]; then
   echo "Error: File $PG_PIT_BACKUP_DIR/$PG_PITR_BACKUP_FILE does not exist"
   exit 1
fi

# Stop Database
systemctl stop postgresql@11-main

# Destroy Database
cd $PG_DIR
rm -rf main/*

# PIT Recovery Database
tar xvfz $PG_PIT_BACKUP_DIR/$PG_PITR_BACKUP_FILE -C $PG_MAIN_DIR

# Check the existence of recovery.conf
if [ -f $PG_MAIN_DIR/recovery.conf ]; then
  rm -rf $PG_MAIN_DIR/recovery.conf
fi

# Add recovery.conf
echo "restore_command='cp /var/lib/postgresql/11/backup/wal/%f %p'" > ./main/recovery.conf
echo "recovery_target_time='$PG_RECOVERY_TIME'" >> ./main/recovery.conf
echo "recovery_target_inclusive = false" >> ./main/recovery.conf

# Change permissions for recovery.conf
chown postgres:postgres ./main/recovery.conf

# # Start Database
# systemctl start postgresql@11-main

# # Delete old Wal-files
# rm -rf $PG_WAL_BACKUP_DIR/*

# # Temporary Delay
# sleep 5

# # Restart Database
# systemctl restart postgresql@11-main

exit 0
