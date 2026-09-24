
# Postgress

## Commands

### Copy to csv
```
\copy {table_name} to {file_path} CSV HEADER
```
### Clear all tables
https://stackoverflow.com/questions/3327312/how-can-i-drop-all-the-tables-in-a-postgresql-database#13823560
```
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO dataklip; --<-- dataklip is the user (normal defaults to postgres).
GRANT ALL ON SCHEMA public TO public;
```

To generate UUIDs

To install the uuid-ossp module, you use the CREATE EXTENSION statement as follows:
```
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

Example update query using UUID
```
UPDATE "User"
SET api_key = uuid_generate_v4()
WHERE username = 'josh';

```

Backup from terminal
```
pg_dump -h 127.0.0.1 -U eltirus eltirus_db -f eltirus_db.2022.03.07.bak
```
## Insert data into calendar table
> Calendar table created via Prisma

```
with recursive cte as (
-- customize start date here
	select date(date_part('year', current_date) || '-01-01') as cdate
union all
	select date(cdate + interval '1 day') as calendar_date
from cte
-- customize end date here
where date_part('year', cdate + interval '1 day') <= date_part('year', current_date + interval '20 year')
)
insert into calendars_calendar (
	cdate,
	day_name,
	day_of_week,
	day_of_month,
	day_of_year,
	week_of_year,
	iso_week_of_year, 
	month_of_year,
	month_name,
	first_of_month,
	last_of_month,
	quarter,
	cyear,
	iso_year,
	is_leap_year
)
select
	cdate,
	to_char(cdate, 'Day') as "day_name",
	date_part ('isodow', cdate) as day_of_week,
	date_part('day', cdate) as day_of_month,
	date_part('doy', cdate) as  day_of_year,
	floor((date_part('doy', cdate)-1)/7)+1 as week_of_year,
	date_part('week', cdate) as iso_week_of_year, 
	date_part('month', cdate) as month_of_year,
	to_char(cdate, 'Month') as month_name,
	(date_trunc('month', cdate))::date as first_of_month,
	(date_trunc('month', cdate) + interval '1 month - 1 day')::date as last_of_month,
	date_part('quarter', cdate) as quarter,
	date_part('year', cdate) as cyear,
	date_part('isoyear', cdate) as iso_year,
	date_part('day', make_date(date_part('year', cdate)::int, 3, 1) - '1 day'::interval) = 29 as is_leap_year
from cte

```
## Create calendar table
```
create table calendars_calendar as
with recursive cte as (
-- customize start date here
	select date(date_part('year', current_date) || '-01-01') as cdate
union all
	select date(cdate + interval '1 day') as calendar_date
from cte
-- customize end date here
where date_part('year', cdate + interval '1 day') <= date_part('year', current_date + interval '3 year')
)
select
	cdate,
	to_char(cdate, 'Day') as "day_name",
	date_part ('isodow', cdate) as day_of_week,
	date_part('day', cdate) as day_of_month,
	date_part('doy', cdate) as  day_of_year,
	floor((date_part('doy', cdate)-1)/7)+1 as week_of_year,
	date_part('week', cdate) as iso_week_of_year, 
	date_part('month', cdate) as month_of_year,
	to_char(cdate, 'Month') as month_name,
	(date_trunc('month', cdate))::date as first_of_month,
	(date_trunc('month', cdate) + interval '1 month - 1 day')::date as last_of_month,
	date_part('quarter', cdate) as quarter,
	date_part('year', cdate) as year,
	date_part('isoyear', cdate) as iso_year,
	date_part('day', make_date(date_part('year', cdate)::int, 3, 1) - '1 day'::interval) = 29 as is_leap_year
from cte;
```