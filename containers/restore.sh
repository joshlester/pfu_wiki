#!/bin/bash

# Ensure current directory is scripts
cd "$(dirname "$0")"

# Script purpose: Restore a previous backup.
echo "Please enter the backup filename (defaults to wikibackup.dump if blank):"
read filename

if [ ! -n filename ]; then
  echo Using default filename of wikibackup.dump
  filename="wikibackup.dump"
fi

filepath="../backups/$filename"
if [ ! -f $filepath ]; then
  echo "$filepath does not exist."
  exit 1
fi

docker exec -it josh_wiki_db dropdb -U josh_wikir db_josh_wiki
docker exec -it josh_wiki_db createdb -U josh_wikir db_josh_wiki
cat $filepath | docker exec -i rendivo_wiki_db pg_restore -U josh_wikir -d db_josh_wiki