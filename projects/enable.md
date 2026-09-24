
# Enable

## Server Setup

### Docker

The build files (including npm depencencies) must be installed on the docker image before running
```docker compose --profile prod up -d```

To do this complete the following steps:
1. Start the container by running:
```
docker run -it -v /srv/www/enable:/srv/www/enable --env PROFILE=prod --entrypoint bash enable/web
```
2. Navigate to the desired build directory e.g. /srv/www/enable/0.7.0
3. Install npm dependencies
```
npm i --prod
```

### Rsync build files to server (which are then added to containers as volumes)
```
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" ./build ./public ./prisma ./remix.config.js ./index.js ./package.json root@149.28.183.7:/srv/www/enable/{build_version_no}
```

```
rsync -avz ./container ./ecosystem.config.js .env root@149.28.183.7:/srv/www/dataklip
```

### Server file location
App files are stored at:

```
/srv/www/enable/current
```

Current is a symbolic link which points to a build folder e.g. current -> 0.1.0
To update the symbolic link to point to a new build:
```
rm current && ln -sfv 0.2.0 current
```

### Container
Build Dataklip web container
```
docker build -t dataklip/web:latest .
```

Start with docker compose
Run in daemon mode. (-d)
*docker-compose.yml expects ../.env file* 
```
docker compose --profile prod up -d
```

### Update build
Install npm production dependencies.
```
npm install --prod
```

Update Prisma (if required)

Show diff for testing
```
npx prisma migrate 
```

Deploy schema changes to db
```
npx prisma migrate deploy
```

Update prisma client
```
npx prisma generate
```

### Update /etc/hosts file
Because the web container access the postgres instance via the db service name i.e.:
DATABASE_URL="postgresql://dataklip:{PASSWORD}@db:5432/dataklip_db?schema=public"
Need to add the below hosts entry so prisma studio (which connects to the DB instance using
the same connection URL) can be accessed remotely.
```
127.0.0.1 db
```

### PM2 entry script (top-level index.js file)
https://github.com/remix-run/remix/issues/1361
Create index.js file based on the advice described at the above URL.
Require so that PM2 can start the app.

### Cloudflare
- Create A record for dataklip.com
- Create CNAME record (alias) for www which points to dataklip.com

### Server configs
Local: ./server_configs/dataklip.conf
Server: /etc/nginx/sites-enabled/dataklip.conf

### Lets encrypt certbot

Generate and install SSL certificates
```
sudo certbot --nginx -d enable.plus -d www.enable.plus -d db.enable.plus -d stocks.enable.plus -d db-stocks.enable.plus -d media.enable.plus --non-interactive --agree-tos -m admin@enable.plus
```

Renewal of certificates is handled by systemd timer see:
https://community.letsencrypt.org/t/cerbot-cron-job/23895/5
```
systemctl list-timers
```