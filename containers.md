
# Containers
<br>

## Tips
> When run a container and referencing a .env file e.g. podman run --env-file .env.dev
Ensure the .env file does _not_ surround the value in double quotes
key="value" &nbsp; &nbsp; :x:
key=value &nbsp; &nbsp; &nbsp; :white_check_mark:

> When building a podman image you can **not** access dir/files outside the build context
the build context is the folder path specified at the end of the podman build command e.g. the current folder "."
is the context for the below command:
```sudo podman build -t 3dviz/rendivo_job_balancer:v1.2 -f container/Dockerfile .```

## References
Example Dockerfile with build stages for creating a Remix app (which includes openssl for Prisma)
 - https://github.com/kentcdodds/remix-tutorial-walkthrough/blob/c4017461026fd6fb7bded627519dba357e6918a1/Dockerfile

## Prune
But with newer versions of Docker (1.13+) there’s an even better command called docker system prune which will not only remove dangling images but it will also remove all stopped containers, all networks not used by at least 1 container, all dangling images and build caches.
```
docker system prune
```

[docker-compose.rendivo.db[not_used].yml](/containers/docker-compose.rendivo.db[not_used].yml)

# Build
```
sudo docker build -t stockible/stockible_server:latest .
```

### Portainer
Pull latest image
```
docker image pull portainer/portainer-ce:latest
```

Deploy
https://documentation.portainer.io/v2.0/deploy/ceinstalldocker/
```
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

```
<br>

### Docker swarm
```
docker swarm leave --force
```

#### Labels
Inspect labels on node:
```
docker node inspect $node_name -f {{.Spec.Labels}}
```

Add Labels on node:
```
docker node update $node_name --label-add $label_key=$label_value (e.g. db=mongo)
```

Clear log
```
: > $(docker inspect --format='{{.LogPath}}' <container_name_or_id>)
```

### Josh Wiki
<br>

#### Files
[[containers/docker-compose.yml|docker-compose.yml]]
[[containers/backup.sh|backup.sh]]
[[containers/restore.sh|restore.sh]]