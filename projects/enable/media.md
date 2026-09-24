
## Deployment

### Sync build files

``` Copy files in dist but not the dist directory itself.```
```bash
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" ./dist/ ./views ./ecosystem.config.js .env ./package.json root@149.28.183.7:/srv/www/enable_media/{build_version_no}
```

### Sync container files
```bash
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv" ./container root@149.28.183.7:/srv/www/enable_media/container
```

### Sync root files
```bash
rsync -avzP -e "ssh -i ~/.ssh/vultr/vultr.prv"./ecosystem.config.js root@149.28.183.7:/srv/www/enable_media
```

## Setup
Current ```current``` symlink in bash (/srv/www/enable_media) directory.
```bash
rm current && ln -sfv 0.1.0 current
```


## Start image without executing ecosystem.config.js script
Dockerfile entrypoint points to bash. This allows image to be run and node_modules to be installed before executing script specified by ecosystem.config.js script property. Note this entrypoint is overridden by docker-compose.yml file.
```bash
docker run -it -v /srv/www/enable_media:/srv/www/enable_media enable/media

```

