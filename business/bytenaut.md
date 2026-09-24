
## Redis

### Redis Commander
```sh
podman run -d --rm \
--name bytenaut-redis-commander \
-p 8081:8081 \
--env-file .redis.env \
rediscommander/redis-commander:latest
```