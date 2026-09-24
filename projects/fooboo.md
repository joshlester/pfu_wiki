
# Fooboo

## Certbot 
```
sudo certbot --nginx -d fooboo.bar -d www.fooboo.bar -d wiki.fooboo.bar --non-interactive --agree-tos -m josh.lester@protonmail.com
```

## Cron
```
 # Backup DB every night at 00:00
 24 0 0 * * * /bin/bash /srv/www/josh_wiki/scripts/backup.sh 2>&1 /srv/www/josh_wiki/logs/cron_db_backup.log

```