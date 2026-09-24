
# Enable Stocks

## Commands
Run Redis Commander to view PROD Redis DB
```bash
podman run --rm --name redis-commander -d --env REDIS_HOST=45.126.125.16 --env REDIS_PASSWORD=*** -p 8081:8081 rediscommander/redis-commander:latest
```

## Compile
Compile queue workers


```Location: project root i.e. .../projects/enable/stocks/```
```bash
./node_modules/typescript/bin/tsc --project tsconfig.queue.json
```

## Deploy

### Install dependencies in dataklip/web_stocks container
```
docker run -v /srv/www/stocks_dataklip:/srv/www/stocks_dataklip --entrypoint bash -it dataklip/web_stocks
```

### folder structure
*  (/srv/www/stocks_dataklip)
|- .env (environment file).
|- container/
|- current (symlink to current build directory)
|- db/
|- ecosystem.config.js (pm2 config must be placed outside build directories)
|- 0.1.0 (build directory)

<br>

### Copy container files to remote
```
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" container .env ecosystem.config.js root@149.28.183.7:/srv/www/stocks_dataklip
```

### Rsync build files to remote
```
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" build build.queue public prisma remix.config.js index.js package.json root@149.28.183.7:/srv/www/enable_stocks/{build_num}
```


## Setup
### Add subdomain
Add subdomains stocks and db-stocks on cloudflare (host provider)
<br>
<img src="/projects/dataklip/stocks/configs/2022-10-02_dataklip_cloudflare_dns.png" width=640 />

### Add nginx configs

1. Create init configs for http only
> Location */etc/nginx/sites-enabled/stocks-dataklip.conf*
```
server {
	listen 80;
	listen [::]:80;
 
	server_name db-stocks.enable.com;
  
	location / {
  	proxy_pass http://127.0.0.1:5433;
	}
}

server {
	listen 80;
	listen [::]:80;
 
	server_name db-stocks.enable.com;
  
	location / {
  	proxy_pass http://127.0.0.1:5433;
	}
}

```
2. Run certbot command
```
sudo certbot --nginx -d {domain.com} -d {www.domain.com} --non-interactive --agree-tos -m {admin@domain.com}
```

## Node project
### About dependencies

#### Remix
-  @remix-run/dev must be included as a dev dependency
https://github.com/remix-run/remix/issues/1233

>I am having the same issue, and I think the issue is related to having this postInstall command:
>"postinstall": "remix setup node"
> 
>This command depends on @remix-run/dev which is a devDependency.
>
>So basically running install command with production flag removes remix cli, and the postInstall command fails.
>
>I hope that helps.
>
>For the time being, for those impacted, moving @remix-run/dev as a production dependency is probably going to fix that. Not sure if the >remix team has any thoughts about that, if that will pose any security concerns.

#### Prisma
https://www.prisma.io/docs/concepts/components/prisma-client/working-with-prismaclient/generating-prisma-client#generating-prisma-client-in-the-postinstall-hook-of-prismaclient

Only the @prisma/client dependency needs to be include as a prod dependency as the prisma lib is automatically fetched and the `prisma generate` command executed as a post-install step


> Generating Prisma Client in the postinstall hook of @prisma/client
>
> The @prisma/client package defines its own postinstall hook that's being executed whenever the package is being installed. This hook
> invokes the prisma generate command which in turn generates the Prisma Client code into the default location node_modules/.prisma 
> /client. Notice that this requires the prisma CLI to be available, either as local dependency or as a global installation. It is
> although recommended to always install the prisma package as a development dependency, using npm install prisma --save-dev, to avoid
> versioning conflicts.

