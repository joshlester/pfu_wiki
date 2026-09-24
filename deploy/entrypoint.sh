#!/usr/bin/env bash
set -e

PUID=${PUID:-33}
PGID=${PGID:-33}
if [ "$PUID" != "33" ]; then
    usermod --uid $PUID www-data || true
fi
if [ "$PGID" != "33" ]; then
    if [ "$PGID" == "0" ]; then
        echo "Fatal: PGID must not be 0 (root)." >&2
        exit 1
    fi
    GROUPNAME=$(getent group $PGID | cut -d':' -f1)
    if [ "$GROUPNAME" != "" ] && [ "$GROUPNAME" != "www-data" ]; then
        groupdel $GROUPNAME
    else
        echo "Info: No need to touch group $GROUPNAME with GID=$PGID."
    fi
    groupmod --gid $PGID www-data || true
fi

if [ ! -d "${OTTERWIKI_REPOSITORY}" ]; then
    mkdir -p "${OTTERWIKI_REPOSITORY}"
fi
if [ ! -d "${OTTERWIKI_REPOSITORY}/.git" ]; then
    git init -b main "${OTTERWIKI_REPOSITORY}"
fi
if [ ! -f "${OTTERWIKI_SETTINGS}" ]; then
    RANDOM_SECRET_KEY=$(echo "$(date) ${RANDOM} ${RANDOM} ${RANDOM}" | md5sum | head -c 32)
    echo "DEBUG = False" >> "${OTTERWIKI_SETTINGS}"
    echo "REPOSITORY = '/app-data/repository'" >> "${OTTERWIKI_SETTINGS}"
    echo "SECRET_KEY = '${RANDOM_SECRET_KEY}'" >> "${OTTERWIKI_SETTINGS}"
    echo "SQLALCHEMY_DATABASE_URI = 'sqlite:////app-data/db.sqlite'" >> "${OTTERWIKI_SETTINGS}"
fi
chown -R www-data:www-data /app-data

USE_NGINX_MAX_UPLOAD=${NGINX_MAX_UPLOAD:-0}
USE_NGINX_WORKER_PROCESSES=${NGINX_WORKER_PROCESSES:-1}
sed -i "/worker_processes\s/c\worker_processes ${USE_NGINX_WORKER_PROCESSES};" /etc/nginx/nginx.conf

USE_STATIC_URL=${STATIC_URL:-'/static'}
export USE_STATIC_PATH=${STATIC_PATH:-'/app/otterwiki/static'}

# Generate nginx site: bind 9010 only (stock entrypoint hardcodes an extra
# listen 8080, which conflicts with signal-cli on this host).
cat > /etc/nginx/sites-enabled/default <<NGINX
server {
    listen 9010;
    client_max_body_size ${USE_NGINX_MAX_UPLOAD};

    location / {
        try_files \$uri @app;
    }
    location @app {
        include uwsgi_params;
        uwsgi_pass unix:///tmp/uwsgi.sock;
        proxy_read_timeout 120s;
        proxy_send_timeout 120s;
    }
    location ${USE_STATIC_URL} {
        alias ${USE_STATIC_PATH};
    }
}
NGINX

for PLUGIN in /app-data/plugins/*/ /plugins/*/; do
    test -d "$PLUGIN" || continue
    echo Installing: $PLUGIN
    cd "$PLUGIN"
    pip install -U . || echo "Error: Installation of plugin in $PLUGIN failed." >&2
done

nginx -t
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf