
# Prisma

## Init a new project
I've been installing prisma as a dependency (--save) not a dev dependency
this is so I can re-generate the client schema in the production environment.
```
npm install --save-dev prisma
npm install @prisma/client
```

Init prisma (specify target DB)
```
npx prisma init --datasource-provider=postgresql
```

Push new schema to dev DB
```
npx prisma db push
```

Reset dev db
```
npx prisma migrate reset
```