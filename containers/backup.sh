#!/bin/bash
# Script purpose: Create a backup of the Rendivo Wiki DB.

# Ensure current directory is script s
cd "$(dirname "$0")"

backup_file_name="josh_wiki_backup.dump"
if [ ! -z $1 ]; then
  if [ $1 == "-t" ]; then
    datestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    backup_file_name="${datestamp}_$backup_file_name"
  fi
fi

docker exec josh_wiki_db pg_dump db_josh_wiki -U josh_wikir -F c > ../backups/$backup_file_name
