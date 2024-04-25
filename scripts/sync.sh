#!/bin/sh

if [[ "$#" -eq 2 ]]; then
    delete="--delete"
    src="$1"
    dest="$2"
elif [[ "$#" -eq 3 && "$1" == "--keep" ]]; then
    delete=""
    src="$2"
    dest="$3"
else
    echo "Invalid number of arguments or format"  >> /log/sync.log 
    echo "Usage: $0 src dest  OR  $0 --keep src dest"  >> /log/sync.log 
    exit 1
fi

src="${src%*/}/"
dest="${dest%*/}"

echo "begin sync: ${src} --> ${dest} ${delete}" >> /log/sync.log 

dest_dirs_file="/config/dest_dirs.config"
if [ -f "$dest_dirs_file" ]; then
    invalid_dest_dir=1
    while IFS= read -r dest_dir; do
        if [ "$dest" == "$dest_dir" ]; then
            invalid_dest_dir=0
        fi
    done < "$dest_dirs_file"
    if [ $invalid_dest_dir -eq 1 ]; then
        echo "sync abort, invalid dest dir: ${dest}" >> /log/sync.log 
        exit 1
    fi
else
    echo "not found dest dir config file: ${dest_dirs_file}"  >> /log/sync.log     
    exit 1
fi

echo "run command: rsync --stats -a ${delete} ${src} ${dest}" >> /log/sync.log 

rsync --stats -a $delete $src $dest >> /log/sync.log 2>&1

echo "finish sync: ${src} --> ${dest} ${delete}" >> /log/sync.log 