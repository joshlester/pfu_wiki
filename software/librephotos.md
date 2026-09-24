
## Container Setup
```yml
version: '3.8'

services:
  librephotos:
    image: reallibrephotos/librephotos-unified:latest
    container_name: librephotos
    restart: unless-stopped
    ports:
      - "3000:8001"
    environment:
      - SERVE_FRONTEND=true
      - DB_BACKEND=sqlite
    volumes:
      - /home/josh/librephotos/db:/db
      - /home/josh/librephotos/protected_media:/protected_media
      - /home/josh/librephotos/logs:/logs
      - /mnt/black_box/media/personal:/data
```
