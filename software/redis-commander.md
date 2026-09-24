
## Links
| Name | URL |
|--- | --- |
| Docker Hub | https://hub.docker.com/r/rediscommander/redis-commander |
| Homepage | https://joeferner.github.io/redis-commander/ |

## Commands
Run Redis Commander using Redis Commander Docker.
```bash
podman run --name redis-commander -p 8081:8081 --env-file=/home/josh/.soup_enable_redis rediscommander/redis-commander
```

```bash
podman run --name redis-commander -p 8081:8081 -e REDIS_HOST=45.126.125.16 -e REDIS_PASSWORD=xxx rediscommander/redis-commander
```