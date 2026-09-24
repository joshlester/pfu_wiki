
## Nginx
<br>

### Setup SSL configuration using lets encrypt

https://eff-certbot.readthedocs.io/en/stable/using.html#certbot-command-line-options

https://www.the-digital-life.com/nginx-reverse-proxy/
-  Install certbot
```
sudo apt install certbot python3-certbot-nginx
```

- Request certificates from lets encrypt
> Ensure request is non-interactive i.e. doesn't halt for user input.
https://stackoverflow.com/questions/49172841/how-to-install-certbot-lets-encrypt-without-interaction

> Running the below automatically creates a cron job entry at:
/etc/cron.d/certbot

```
sudo certbot --nginx -d {domain.com} -d {www.domain.com} --non-interactive --agree-tos -m {admin@domain.com}
```

```
```
