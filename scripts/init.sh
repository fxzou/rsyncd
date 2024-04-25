#!/bin/sh

backup_dir="/config/backup"
timestamp=$(date "+%Y%m%d%H%M%S")
cron_file="/etc/crontabs/root"
backup_file="corn_backup_${timestamp}.bak"
task_dir="/config/tasks"
log_dir="/log"

if [ ! -d "$log_dir" ]; then
    mkdir "$log_dir"
    touch "${log_dir}/sync.log"
fi

[ -d "${backup_dir}" ] || mkdir -p ${backup_dir}
cp $cron_file $backup_dir/$backup_file
echo 'backup cron file success' >> /log/sync.log
num_backups=$(ls -1 $backup_dir | wc -l)
if [ $num_backups -gt 10 ]; then
    oldest_backup=$(ls -t $backup_dir | tail -n 1)
    rm $backup_dir/$oldest_backup
    echo "remove oldest backup cron file success: ${oldest_backup}" >> /log/sync.log
fi

rm $cron_file
touch $cron_file
[ -d "${task_dir}" ] || mkdir -p $task_dir
cat $task_dir/*.task > $cron_file 2>/dev/null

echo "setup cron file success, new cron file: " >> /log/sync.log
cat $cron_file >> /log/sync.log