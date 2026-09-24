
# Prisma Workflow

## Apply changes to db using migrations
### Standard
1.1 Edit prisma.schema file
1.2 Run command
```
npx prisma migrate dev --name "name_of_migration"
```

### Edit migration before applying to db 

2.1 Edit schema.prisma file
2.2 Run migration --create-only command
```
npx prisma migrate dev --create-only. A migration .sql file will be generated
```
2.3. Edit the migration (.sql) file
2.4 Run migration command to apply migration to db
```
npx prisma migrate dev
```

2. After prisma folder is copied to prod
Navigate to newly uploaded build folder e.g. 0.3.0

- 2.1 Update database by running
```
npx prisma migrate deploy
```
- 2.2 Update prisma client by running
```
npx prisma generate
```