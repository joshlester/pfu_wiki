
## Setup

1. Generate cert & key file
``` Ensure cert & key file are readable by docker```
``` e.g. chmod +r server.crt server.key```
```bash
openssl req -x509 -newkey rsa:4096 -nodes -keyout server.key -out server.crt -days 36500
```

2. Create server.json file
```json
{
  "SSL": true,
  "SSLCert": "server.crt",
  "SSLKey": "server.key",
  "ServerMode": true,
  "AllowRemoteConnections": true
}
```

Futher instuctions at:
https://www.pgadmin.org/docs/pgadmin4/latest/container_deployment.html

example docker-compose file:
```yaml
version: '3.9'
services:
  pgadmin:
    container_name: pg_admin
    image: dpage/pgadmin4
    env_file:
      - stack.env
    restart: always
    ports:
      - 8091:443
    volumes:
      - /etc/ssl/certs/pgadmin.crt:/certs/server.cert:ro
      - /etc/ssl/certs/pgadmin.key:/certs/server.key:ro
      - /home/pg_admin/servers.json:/pgadmin4/servers.json

```