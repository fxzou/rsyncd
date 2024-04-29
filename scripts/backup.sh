#!/bin/sh
cd ~
src_args=$@
echo "begin sync: $src_args" >> /log/backup.log 

delete=""
exclude=""
while getopts ":de:" opt; do
  case $opt in
    d)
      delete=" --delete"
      ;;
    e)
      exclude="$exclude --exclude $OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >> /log/backup.log 
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

if [[ "$#" -eq 2 ]]; then
    src="$1"
    dest="$2"
else
    echo "Invalid number of arguments or format"  >> /log/backup.log 
    echo "Usage: $0 src dest OR $0 -d -e excludefile src dest"  >> /log/backup.log 
    exit 1
fi

src="${src%*/}/"
dest="${dest%*/}"

dest_dirs_file="/config/dest_dirs.config.txt"
if [ -f "$dest_dirs_file" ]; then
    invalid_dest_dir=1
    while IFS= read -r dest_dir || [ -n "$line" ]; do
        if [ "$dest" == "$dest_dir" ]; then
            invalid_dest_dir=0
        fi
    done < "$dest_dirs_file"
    if [ $invalid_dest_dir -eq 1 ]; then
        echo "sync abort, invalid dest dir: ${dest}" >> /log/backup.log 
        exit 1
    fi
else
    echo "not found dest dir config file: ${dest_dirs_file}"  >> /log/backup.log     
    exit 1
fi

echo "run command: rsync --stats -ah${delete}${exclude} ${src} ${dest}" >> /log/backup.log 

rsync --stats -ah$delete$exclude $src $dest >> /log/backup.log 2>&1

echo "finish sync: $src_args" >> /log/backup.log 