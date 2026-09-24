
# Eltirus Enable Server

### Crontab
Call EE API to pull weightrax data every 5 mins
#### wget call
*Note -O switch redirects output file to the void.* 
```
wget -a /var/log/eltirus_enable/eltirus_enable_cron_pull_weightrax_data.log -O /dev/null --read-timeout 60 --post-data "" http://128.199.196.212:3002/connector/weightrax/visits-by-date-range?save=1
```

#### Crontab
```
*/5 * * * * wget -a /var/log/eltirus_enable/eltirus_enable_cron_pull_weightrax_data.log -O /dev/null --read-timeout 60 --post-data "" http://128.199.196.212:3002/connector/weightrax/visits-by-date-range?save=1
```

## Install

### Install the SQL Server command-line tools sqlcmd and bcp on Linux
> Cannot backup Azure SQL server using sqlcmd

Running the following scripts results in the error below.
```
#!/bin/bash

###
# Create By: Josh Lester (josh.lester@eltirus.com.au)
# Create on: 2022-07-04
#
# Purpose
# To create a local backup of the Eltirus Enable DB
#
# See https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-backup-and-restore-database?view=sql-server-ver16
##
CURRENT_DATE=$(date +"%Y-%m-%d")
COMMAND="BACKUP DATABASE [db_eltirus_enable] TO DISK = '/var/opt/mssql/data/${CURRENT_DATE}_db_eltirus_enable.bak' WITH NOFORMAT, NOINIT, NAME = 'db_eltirus_enable-full', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
echo "${COMMAND}"
sqlcmd -S srv-eltirus-enable-01.database.windows.net -U eltirus_enable_01 -P 'XXXXXXXXXX' -Q "$COMMAND"
```
*Statement 'BACKUP DATABASE' is not supported in this version of SQL Server.
Used to perform automated backups of the SQL Server DB*

https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver16