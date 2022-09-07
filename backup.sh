#!/bin/bash
DATE=$(date +%Y-%m-%d-%H-%M)
BACKUPDIR=/root/backup/backup_${DATE}
DATADIR=$HOME/.near/data/*
NEW_BACKUP_FILE=$BACKUP_DATA.zip

mkdir ${BACKUPDIR}

# delete old backup
OLD_BACKUPS=`ls $BACKUP_DIR/*.zip`
for file in $OLD_BACKUPS
  do
     rm $file
     if [ ! -d "$file" ]; then
       echo "$file has been deleted" | ts
     fi
  done

sudo systemctl stop $service
wait
echo "NEAR node was stopped" | ts

if [ -d "$BACKUPDIR" ]; then
    echo "Backup started" | ts

    cd "${BACKUPDIR}backup_${DATE}"
    tar -czf data.tar.gz -C $DATADIR .
    
    curl -fsS -m 10 --retry 5 -o /dev/null https://hc-ping.com/8226f1e8-3472-4982-b7d5-b1705035d9e9

    echo "Backup completed" | ts
else
    echo $BACKUPDIR is not created. Check your permissions.
    exit 0
fi
cd
sudo systemctl start neard.service
echo "NEAR node was started" | ts
