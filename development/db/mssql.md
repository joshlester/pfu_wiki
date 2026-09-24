
# TSQL

## T-SQL snippets 
<br />

### List MS SQL Server Backups
<span id="ms-sql-server-backups" />

```sql
SELECT *
FROM sys.dm_database_backups 
ORDER BY backup_finish_date DESC;
```

### String concatenation
https://stackoverflow.com/questions/7003228/t-sql-string-concatenating-multiple-rows
```sql
SELECT p1.CategoryId,
      ( SELECT ProductName + ',' 
          FROM Northwind.dbo.Products p2
         WHERE p2.CategoryId = p1.CategoryId
         ORDER BY ProductName
           FOR XML PATH('') ) AS Products
  FROM Northwind.dbo.Products p1
 GROUP BY CategoryId ;
```
<br />