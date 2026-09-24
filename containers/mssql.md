
# MS SQL Containers

Run command
https://hub.docker.com/_/microsoft-mssql-server
```
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=6RiM2V5hb3No9tC" -e "MSSQL_PID=Developer" -p 1433:1433 -d mcr.microsoft.com/mssql/server:2019-CU14-ubuntu-20.04
```		