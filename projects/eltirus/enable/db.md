
## Queries

### Users
```sql
SELECT *
FROM users_user uu 
JOIN users_user_role uur ON (uu.id = uur.user_id)
JOIN roles_role rr ON (uur.role_id = rr.id)
WHERE rr.[key] = 'ADMIN'
```