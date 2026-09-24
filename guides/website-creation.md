
# Website Creation Guide

## Web Server

### Nginx 

Add website configuration to to /etc/nginx/sites-enable
Example config:
```
server {
    listen 80;
    listen [::]:80;

    server_name db.enable.plus;

    location / {
         proxy_pass http://127.0.0.1:5435;
    }
}

server {
    listen 80;
    listen [::]:80;

    server_name enable.plus www.enable.plus;

    return 301 https://$server_name$request_uri;
}
```

After creating initial config add https support by running the following certbot command
```
sudo certbot --nginx -d {sub1.domain.com} -d {sub2.domain.com} -d {domain.com} --non-interactive --agree-tos -m {admin@domain.com}
```
Certbot should automatically update the relevant config file (i.e. the config file which contains the domain which was entered into the certbox command) with the relevant SSL options.
```
 server {
     listen [::]:443 ssl; # managed by Certbot
     listen 443 ssl; # managed by Certbot
 
     ssl_certificate /etc/letsencrypt/live/enable.plus/fullchain.pem; # managed by Certbot
     ssl_certificate_key /etc/letsencrypt/live/enable.plus/privkey.pem; # managed by Certbot
     include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
     ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
 
     server_name enable.plus www.enable.plus;
 
     location / {
         proxy_pass http://127.0.0.1:3005;
     }
 }
```
