
# Queries
<br />

## Module Queries
### List all client site modules
```sql
SELECT
	cc.client_id,
	ss.id as site_id,
	ss.site_id as site_key,
	ss.site_name,
	mcm.id as module_id,
	mcm.name as module_name
FROM
	modules_site_module msm
INNER JOIN modules_client_module mcm ON
	(msm.module_id = mcm.id)
INNER JOIN clients_client cc ON
	(mcm.client_id = cc.id )
INNER JOIN sites_site ss ON
	(cc.client_id = ss.client_id )

```
### Update client module and all nav page references
```sql
BEGIN TRANSACTION;

-- Update the category in the modules_client_module table
UPDATE modules_client_module
SET category = 'CRUSH_SCREEN_SPLITS'
WHERE category = 'CRUSH_SCREEN_BY_YIELD';

-- Update the module_category in the roles_nav_page table
UPDATE roles_nav_page
SET module_category = 'CRUSH_SCREEN_SPLITS'
WHERE module_category = 'CRUSH_SCREEN_BY_YIELD';

COMMIT;
```