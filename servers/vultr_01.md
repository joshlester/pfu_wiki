
# Vultr 01

## Files

| File | Description |
| --- | --- |
| /var/spool/cron/crontabs/root | Crontab file |


## Copy files
Copy nginx configs
```
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" root@149.28.183.7:/etc/nginx/nginx.conf :/etc/nginx/nginx.conf.dpkg-old :/etc/nginx/sites-enabled ~/Downloads
```
Copy crontab from server to local
```
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" root@149.28.183.7:/var/spool/cron/crontabs/root ~/Downloads
```
Copy .vimrc to home dir.
```
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" .vimrc root@149.28.183.7:~
```

## Files
- [[servers/vultr_01/root.crontab|root.crontab]]
- [[servers/vultr_01/nginx.conf|nginx.conf]]
- [[servers/vultr_01/sites-enabled/dataklip.conf|dataklip.conf]]
- [[servers/vultr_01/sites-enabled/fooboo.conf|fooboo.conf]]
- [[servers/vultr_01/sites-enabled/stockible.conf|stockible.conf]]
- [[servers/vultr_01/sites-enabled/stocks-dataklip.conf|stocks-dataklip.conf]]