
# Eltirus Enable
<br />

## Plant - Changing ID
 - Need to manually update plant ID in the `clients_client_metric` table

## Stocks Page
Inorder for MANUAL-SPLITS products which are stored in `production_plant_config_product_tonnes` to appear in the Production column their Site Product Code e.g. WAIN_G2 must exist in the `Products Site Product` table

## Database
- [[development/db/mssql#ms-sql-server-backups|View Azure SQL Backups]]

## Data Model

TODO: Remove plants_plant_target_key_value and v_clients_client_metric_value in favour of:
Client Metrics table.



## Build docker image
```From within enable directory root e.g. /projects/eltirus/eltirus_enable```
```
docker build -t eltirus/enable:v0.4.7 -f .\container\Dockerfile .
```

- Use Docker Desktop to push image to Docker Hub


## Dev need to knows (NTK)
- package.json - @remix-rum/dev is included in production dependencies so that remix installs correctly on the server when running `npm -i --prod`

## Deploy to Azure
<br>

### Deploy app files
1. Navigate to the project directory *e.g. c:/Users/JoshLester/projects/eltirus/eltirus_enable*

2. ~~Update .env file to point to Production.~~. Env variables are sourced via Portainer stack.

2. Copy the production files to a new build directory e.g. 0.3.2 on the server
```
rsync -avzP -e "ssh -i ~/.ssh/eltirus_enable_vm_01.prv" build public prisma package.json eltirus_enable_01@20.211.108.35:/srv/www/eltirus_enable/0.1.0
```

3. Copy assets to public directory (required since upgrading remix to use vite)
*From within the app directory e.g. 0.32.2*
```
cp -R build/client/assets/ public/
```

3. SSH into the server and install the nodes dependencies for the new build by executing the following command inside the running docker container.

To access the running docker container (in the server terminal)
```
docker exec -it 16 /bin/bash
```

- Navigate to the new build directory

- Install node dependencies
```
npm i --prod
```

4. From the server terminal (don't need to be in the running container bash) point current to new build
```
rm current && ln -sfv 0.3.2 current
```

5. Confirm new build is running by visiting
https://enable.eltirus.com
<br />


### Deploy container files
```
rsync -avzP -e "ssh -i /home/josh/.ssh/eltirus_enable/eltirus_enable_vm_01.prv" ecosystem.config.cjs container eltirus_enable_01@20.211.108.35:/srv/www/eltirus_enable
```

## Process to upgrade build
1. rsync file dev machine.
2. update .env file to use prod variables (look to automate this).
2. start and bash into container.
3. run npm install.
4. Update DB scheme and generate prisma client
5. exit container.
6. run docker compose up.


## Commands
### Docker Commands
```
docker compose down --remove-orphans
```
```
docker logs enable_web 
```
```
docker compose --profile prod up -d
```
```
docker run -it -v /srv/www/eltirus_enable:/srv/www/eltirus_enable --entrypoint /bin/bash eltirus/enable_web
```
```
sudo docker build -t eltirus/enable_web:latest -t eltirus/enable_web:v0.1.0 .
```
<br>

### Update existing build
If you upload updated files to an existing build e.g. Run the following command when the build 0.3.6 has already been created.
```
rsync -avzP -e "ssh -i ~/.ssh/eltirus_enable_vm_01.prv" build public prisma remix.config.js index.js .env package.json eltirus_enable_01@20.211.108.35:/srv/www/eltirus_enable/0.3.6
```
Make sure to restart PM2 process
```
pm2 restart {process_id}
```


### Certbot (SSL)
Note: Running the command below resulted in Certbot lines being inserted
into the default config file. Ensure these lines are removed from the default
config.

Also need to edit the generated config files based on this comment
https://github.com/certbot/certbot/issues/5550#issuecomment-527236301

>In case of multiple domains
Instead of
listen [::]:443 ssl http2 ipv6only=on;
Use
listen example.com:443 ssl http2 ipv6only=on;

```
sudo certbot --nginx -d enable.eltirus.com -d enable-stage.eltirus.com -d enable-dev.eltirus.com --non-interactive --agree-tos -m josh.lester@eltirus.com
```

### SQL Server Commands
Create enable db
```
-- Create a new database called 'db_eltirus_enable'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'db_eltirus_enable'
)
CREATE DATABASE db_eltirus_enable
GO
```

## Install python/pip on Linux alpine
https://stackoverflow.com/questions/62554991/how-do-i-install-python-on-alpine-linux
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools


<br>

## Deploy to Digital Ocean
Deploy app files
```
rsync -avzP -e "ssh -i /home/josh/.ssh/eltirus_01.prv.key" ./build ./public ./prisma ./remix.config.js ./index.js .env ./package.json root@128.199.196.212:/srv/www/eltirus_insights/0.3.0
```

deploy environment files
```
rsync -avzP -e "ssh -i /home/josh/.ssh/eltirus_01.prv.key" ./ecosystem.config.js root@128.199.196.212:/srv/www/eltirus_insights
```

## Lessons learned

### npm i --prod on different version of node
**Scenario**
I was installing node modules by running npm i --prod command on
docker host which had a different version than the docker container
which resulted in an error.

*Note if using xml2json expect ugly warning output, this is not an error*
https://github.com/buglabs/node-xml2json/issues/177
```
patrikx3@bitang:~/Projects/patrikx3/p3x/xml2json$ rm -rf node_modules/
patrikx3@bitang:~/Projects/patrikx3/p3x/xml2json$ node -v
v12.13.0
patrikx3@bitang:~/Projects/patrikx3/p3x/xml2json$ npm install

> node-expat@2.3.18 install /home/patrikx3/Projects/patrikx3/p3x/xml2json/node_modules/node-expat
> node-gyp rebuild

make: Entering directory '/home/patrikx3/Projects/patrikx3/p3x/xml2json/node_modules/node-expat/build'
  CC(target) Release/obj.target/expat/deps/libexpat/lib/xmlparse.o
  CC(target) Release/obj.target/expat/deps/libexpat/lib/xmltok.o
In file included from ../deps/libexpat/lib/xmltok.c:306:0:
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_isPublicId’:
../deps/libexpat/lib/xmltok_impl.c:1404:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (!(BYTE_TO_ASCII(enc, ptr) & ~0x7f))
          ^
../deps/libexpat/lib/xmltok_impl.c:1406:5: note: here
     default:
     ^~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_sameName’:
../deps/libexpat/lib/xmltok_impl.c:1624:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (*ptr1++ != *ptr2++) \
          ^
../deps/libexpat/lib/xmltok_impl.c:1626:5: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
     ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1623:5: note: here
     case BT_LEAD ## n: \
     ^
../deps/libexpat/lib/xmltok_impl.c:1626:18: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                  ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1624:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (*ptr1++ != *ptr2++) \
          ^
../deps/libexpat/lib/xmltok_impl.c:1626:18: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                  ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1623:5: note: here
     case BT_LEAD ## n: \
     ^
../deps/libexpat/lib/xmltok_impl.c:1626:31: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                               ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_scanRef’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:509:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:509:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:518:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:518:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_scanPercent’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:886:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:886:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:896:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:896:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_scanLt’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:693:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:693:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:731:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:731:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:743:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:743:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:720:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:720:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_scanPi’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:246:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:246:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:253:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:253:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_scanEndTag’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:397:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:397:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:404:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:404:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_scanAtts’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:552:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:552:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:649:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:649:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:541:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:541:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_prologTok’:
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:1153:9: note: in expansion of macro ‘CHECK_NAME_CASES’
         CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
         ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:1153:9: note: in expansion of macro ‘CHECK_NAME_CASES’
         CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
         ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:1139:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:1139:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘normal_scanPoundName’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:914:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:914:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:921:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:921:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
In file included from ../deps/libexpat/lib/xmltok.c:791:0:
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_isPublicId’:
../deps/libexpat/lib/xmltok_impl.c:1404:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (!(BYTE_TO_ASCII(enc, ptr) & ~0x7f))
          ^
../deps/libexpat/lib/xmltok_impl.c:1406:5: note: here
     default:
     ^~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_sameName’:
../deps/libexpat/lib/xmltok_impl.c:1624:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (*ptr1++ != *ptr2++) \
          ^
../deps/libexpat/lib/xmltok_impl.c:1626:5: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
     ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1623:5: note: here
     case BT_LEAD ## n: \
     ^
../deps/libexpat/lib/xmltok_impl.c:1626:18: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                  ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1624:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (*ptr1++ != *ptr2++) \
          ^
../deps/libexpat/lib/xmltok_impl.c:1626:18: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                  ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1623:5: note: here
     case BT_LEAD ## n: \
     ^
../deps/libexpat/lib/xmltok_impl.c:1626:31: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                               ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_scanRef’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:509:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:509:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:518:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:518:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_scanPercent’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:886:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:886:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:896:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:896:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_scanLt’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:693:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:693:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:731:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:731:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:743:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:743:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:720:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:720:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_scanPi’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:246:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:246:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:253:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:253:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_scanEndTag’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:397:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:397:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:404:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:404:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_scanAtts’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:552:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:552:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:649:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:649:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:541:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:541:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_prologTok’:
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:1153:9: note: in expansion of macro ‘CHECK_NAME_CASES’
         CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
         ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:1153:9: note: in expansion of macro ‘CHECK_NAME_CASES’
         CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
         ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:1139:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:1139:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘little2_scanPoundName’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:914:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:914:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:921:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:921:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
In file included from ../deps/libexpat/lib/xmltok.c:932:0:
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_isPublicId’:
../deps/libexpat/lib/xmltok_impl.c:1404:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (!(BYTE_TO_ASCII(enc, ptr) & ~0x7f))
          ^
../deps/libexpat/lib/xmltok_impl.c:1406:5: note: here
     default:
     ^~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_sameName’:
../deps/libexpat/lib/xmltok_impl.c:1624:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (*ptr1++ != *ptr2++) \
          ^
../deps/libexpat/lib/xmltok_impl.c:1626:5: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
     ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1623:5: note: here
     case BT_LEAD ## n: \
     ^
../deps/libexpat/lib/xmltok_impl.c:1626:18: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                  ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1624:10: warning: this statement may fall through [-Wimplicit-fallthrough=]
       if (*ptr1++ != *ptr2++) \
          ^
../deps/libexpat/lib/xmltok_impl.c:1626:18: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                  ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:1623:5: note: here
     case BT_LEAD ## n: \
     ^
../deps/libexpat/lib/xmltok_impl.c:1626:31: note: in expansion of macro ‘LEAD_CASE’
     LEAD_CASE(4) LEAD_CASE(3) LEAD_CASE(2)
                               ^~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_scanRef’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:509:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:509:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:518:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:518:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_scanPercent’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:886:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:886:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:896:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:896:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_scanLt’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:693:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:693:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:731:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:731:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:743:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:743:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:720:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:720:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_scanPi’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:246:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:246:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:253:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:253:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_scanEndTag’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:397:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:397:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:404:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:404:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_scanAtts’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:552:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:552:7: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
       CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
       ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:649:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:649:11: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
           CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
           ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:541:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:541:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_prologTok’:
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:1153:9: note: in expansion of macro ‘CHECK_NAME_CASES’
         CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
         ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:1153:9: note: in expansion of macro ‘CHECK_NAME_CASES’
         CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
         ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:1139:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:1139:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c: In function ‘big2_scanPoundName’:
../deps/libexpat/lib/xmltok_impl.c:74:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NMSTRT_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:914:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:78:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:914:3: note: in expansion of macro ‘CHECK_NMSTRT_CASES’
   CHECK_NMSTRT_CASES(enc, ptr, end, nextTokPtr)
   ^~~~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:46:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
     if (!IS_NAME_CHAR_MINBPC(enc, ptr)) { \
        ^
../deps/libexpat/lib/xmltok_impl.c:921:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
../deps/libexpat/lib/xmltok_impl.c:50:3: note: here
   case BT_NMSTRT: \
   ^
../deps/libexpat/lib/xmltok_impl.c:921:5: note: in expansion of macro ‘CHECK_NAME_CASES’
     CHECK_NAME_CASES(enc, ptr, end, nextTokPtr)
     ^~~~~~~~~~~~~~~~
  CC(target) Release/obj.target/expat/deps/libexpat/lib/xmlrole.o
  AR(target) Release/obj.target/deps/libexpat/libexpat.a
  COPY Release/libexpat.a
  CXX(target) Release/obj.target/node_expat/node-expat.o
  SOLINK_MODULE(target) Release/obj.target/node_expat.node
  COPY Release/node_expat.node
make: Leaving directory '/home/patrikx3/Projects/patrikx3/p3x/xml2json/node_modules/node-expat/build'
added 985 packages from 1526 contributors in 12.784s
```

 [Bug]: During postinstall, "remix is not recognized as a command" error #1233 
 https://github.com/remix-run/remix/issues/1233
https://github.com/remix-run/remix/issues/1233#issuecomment-1005199127


