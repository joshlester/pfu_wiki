
## Links
https://docs.portainer.io/start/install/server/docker/linux

## Upgrade Portainer Docker
https://docs.portainer.io/start/upgrade/docker
```bash
docker stop portainer
docker rm portainer
docker pull portainer/portainer-ce:latest
docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
```

### Issues 
<br/>

## Unable to start Portainer Agent

### Error
>2023/05/18 02:00AM INF github.com/portainer/agent/cmd/agent/main.go:86 > agent running on Docker platform |
2023/05/18 02:00AM INF github.com/portainer/agent/cmd/agent/main.go:101 > agent running on a Swarm cluster node. Running in cluster mode |
2023/05/18 02:00AM WRN github.com/portainer/agent/cmd/agent/main.go:112 > unable to retrieve agent container IP address, using host flag instead | error="unable to retrieve the address on which the agent can advertise. Check your network settings" host_flag=0.0.0.0
2023/05/18 02:00AM FTL github.com/portainer/agent/cmd/agent/main.go:141 > unable to retrieve a list of IP associated to the host | error="lookup tasks. on 1.1.1.1:53: no such host" host=tasks.

### Fix
Leave the docker swarm
```
sudo docker swarm leave --force
```