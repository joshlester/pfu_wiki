
# Eltirus Enable Development

## Local dev environment
The db connection URL in the .env file references db. Because the app docker image isn't running in a local dev environment i.e. only the db docker images is started. Update hosts file to include the following:
```
127.0.0.1 db
```
