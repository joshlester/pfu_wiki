
# Mysql
## Backup & restore
```
pv 'rendivo001db (02-06-2022).sql' | mysql -uroot -p -D rendivo001db
```

## User
### Create user

Create user with password
```
CREATE USER 'report'@'%' IDENTIFIED BY 'secret';
```
Create user without password
```
CREATE USER 'report'@'%';
```
The % in the command above means that user report can be used to connect from any host. You can limit the access by defining the host from where the user can connect. Omitting this information will only allow the user to connect from the same machine.

### Edit user
Change user's IP address
*(This takes care of all grants)*
```
RENAME USER user@ipaddress1 TO user@ipaddress2;
```

### Permissions
Show permissions for current user
```
show grants; 
```

Show permissions for specific user
```
show grants for haproxy;
```

Grant SELECT permissions for all tables in rendivo_db database.
```
GRANT SELECT ON rendivo_db.* TO 'haproxy'@'%';
```

### List users
SELECT user,host FROM mysql.user;

### Drop user
DROP USER haproxy@192.168.1.6;


## Rendivo
* Update name column in Products Product Client Affiliation by removeing builder company name
```
SET @target = '| Clarendon Homes';
UPDATE rendivo001db.products_product_client_affiliation ppca
SET ppca.name=replace(name, @target, '')
WHERE
    ppca.client_id = 'BRIC' AND
    ppca.name LIKE CONCAT('%', @target, '%');
```

* Update scheme name in stateXml column by remove builder company name
```
SET @target = 'New Edge Homes | ';
UPDATE rendivo001db.users_schemes us
SET us.stateXml = REPLACE(stateXml, @target, '')
WHERE
   us.client_company_id = 'BRIC'
```