
## Service deprecated

The Enable Auth service has been deprecated in favour of the Azure Easy Auth service.

Removed the following env var from Enable app:
 - [DEV] ENABLE_AUTH_ENDPOINT=http://localhost:3000
 - [PROD] ENABLE_AUTH_ENDPOINT="https://enable-auth.eltirus.com"

## Deploy

Deploy files to Azure Server 
```
rsync -avzP --exclude="node_modules/" -e "ssh -i ~/.ssh/eltirus_enable_vm_01.prv" app container ecosystem.config.js eltirus_enable_01@20.211.108.35:/srv/www/enable_auth/0.1.0
```

## Docker

### Run container from terminal
```
docker run -it -v /srv/www/enable_auth/current/:/var/www/enable_auth --entrypoint /bin/bash eltirus/enable_auth
```

### Build Enable Auth Docker Image.
```
docker build -t eltirus/enable_auth:latest -t eltirus/enable_auth:v1 .
```

### nginx
```
sudo certbot --nginx -d enable-auth.eltirus.com --non-interactive --agree-tos -m josh.lester@eltirus.com
```