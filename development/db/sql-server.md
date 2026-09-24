
# SQL Server

## Create new DB
```
-- Create a new database called 'DatabaseName'
-- Connect to the 'master' or Any database to run this snippet
USE master  
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'DatabaseName'
)
CREATE DATABASE DatabaseName
GO
```
## Copy table from one db to another
https://www.sqlshack.com/how-to-copy-tables-from-one-database-to-another-in-sql-server/

## Set date column to not null
```
   ALTER TABLE
  calendar
ALTER COLUMN
  [date]
    date NOT NULL;
```

## Create primary key in existing table
```
ALTER TABLE Production.TransactionHistoryArchive
   ADD CONSTRAINT PK_TransactionHistoryArchive_TransactionID PRIMARY KEY CLUSTERED (TransactionID);
```
## Populate calendar table
```SQL
DECLARE @StartDate  date = '20220101';

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 20, @StartDate));

;WITH
    seq(n)
    AS
    (
                    SELECT 0
        UNION ALL
            SELECT n + 1
            FROM seq
            WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
    ),
    d(d)
    AS
    (
        SELECT DATEADD(DAY, n, @StartDate)
        FROM seq
    ),
    src
    AS
    (
        SELECT
            [date]         = CONVERT(date, d),
            day          = DATEPART(DAY,       d),
            day_name      = DATENAME(WEEKDAY,   d),
            week         = DATEPART(WEEK,      d),
            [iso_week]      = DATEPART(ISO_WEEK,  d),
            day_of_week    = DATEPART(WEEKDAY,   d),
            month        = DATEPART(MONTH,     d),
            month_name    = DATENAME(MONTH,     d),
            quarter      = DATEPART(Quarter,   d),
            year         = DATEPART(YEAR,      d),
            first_of_month = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
            last_of_year   = DATEFROMPARTS(YEAR(d), 12, 31),
            day_of_year    = DATEPART(DAYOFYEAR, d)
        FROM d
    ),
    dim
    AS
    (
        SELECT
            [date],
            day,
            day_suffix        = CONVERT(char(2), CASE WHEN day / 10 = 1 THEN 'th' ELSE
                            CASE RIGHT(day, 1) WHEN '1' THEN 'st' WHEN '2' THEN 'nd'
                            WHEN '3' THEN 'rd' ELSE 'th' END END),
            day_name,
            day_of_week,
            day_of_week_in_month = CONVERT(tinyint, ROW_NUMBER() OVER
                            (PARTITION BY first_of_month, day_of_week ORDER BY [date])),
            day_of_year,
            is_weekend           = CASE WHEN day_of_week IN (1, 7) THEN 1 ELSE 0 END,
            week,
            [iso_week],
            first_of_week      = DATEADD(DAY, 1 - day_of_week, [date]),
            last_of_week       = DATEADD(DAY, 6, DATEADD(DAY, 1 - day_of_week, [date])),
            week_of_month      = CONVERT(tinyint, DENSE_RANK() OVER
                            (PARTITION BY year, month ORDER BY week)),
            month,
            month_name,
            first_of_month,
            last_of_month      = MAX([date]) OVER (PARTITION BY year, month),
            first_of_next_month = DATEADD(MONTH, 1, first_of_month),
            last_of_next_month  = DATEADD(DAY, -1, DATEADD(MONTH, 2, first_of_month)),
            quarter,
            first_of_quarter   = MIN([date]) OVER (PARTITION BY year, quarter),
            last_of_quarter    = MAX([date]) OVER (PARTITION BY year, quarter),
            year,
            iso_year          = year - CASE WHEN month = 1 AND [iso_week] > 51 THEN 1
                            WHEN month = 12 AND [iso_week] = 1  THEN -1 ELSE 0 END,
            first_of_year      = DATEFROMPARTS(year, 1,  1),
            last_of_year,
            is_leap_year          = CONVERT(bit, CASE WHEN (year % 400 = 0)
                OR (year % 4 = 0 AND year % 100 <> 0)
                            THEN 1 ELSE 0 END),
            has_53_weeks          = CASE WHEN DATEPART(WEEK,     last_of_year) = 53 THEN 1 ELSE 0 END,
            has_53_iso_weeks       = CASE WHEN DATEPART(ISO_WEEK, last_of_year) = 53 THEN 1 ELSE 0 END,
            mm_yyyy              = CONVERT(char(2), CONVERT(char(8), [date], 101))
                          + '-' + CONVERT(char(4), year)
        FROM src
    )
insert INTO calendars_calendar (
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
            is_leap_year )
select [date],
            day_name,
            day_of_week,
            day_of_week_in_month,
            day_of_year,
            week,
            [iso_week],
            month,
            month_name,
            first_of_month,
            last_of_month,
            quarter,
            year,
            iso_year,
            is_leap_year
FROM dim
ORDER BY [date]
OPTION
(MAXRECURSION
0);
```


## Create calendar table
https://www.mssqltips.com/sqlservertip/4054/creating-a-date-dimension-or-calendar-table-in-sql-server/
```


DECLARE @StartDate  date = '20200101';

DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 20, @StartDate));

;WITH
    seq(n)
    AS
    (
                    SELECT 0
        UNION ALL
            SELECT n + 1
            FROM seq
            WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
    ),
    d(d)
    AS
    (
        SELECT DATEADD(DAY, n, @StartDate)
        FROM seq
    ),
    src
    AS
    (
        SELECT
            [date]         = CONVERT(date, d),
            day          = DATEPART(DAY,       d),
            day_name      = DATENAME(WEEKDAY,   d),
            week         = DATEPART(WEEK,      d),
            [iso_week]      = DATEPART(ISO_WEEK,  d),
            day_of_week    = DATEPART(WEEKDAY,   d),
            month        = DATEPART(MONTH,     d),
            month_name    = DATENAME(MONTH,     d),
            quarter      = DATEPART(Quarter,   d),
            year         = DATEPART(YEAR,      d),
            first_of_month = DATEFROMPARTS(YEAR(d), MONTH(d), 1),
            last_of_year   = DATEFROMPARTS(YEAR(d), 12, 31),
            day_of_year    = DATEPART(DAYOFYEAR, d)
        FROM d
    ),
    dim
    AS
    (
        SELECT
            [date],
            day,
            day_suffix        = CONVERT(char(2), CASE WHEN day / 10 = 1 THEN 'th' ELSE 
                            CASE RIGHT(day, 1) WHEN '1' THEN 'st' WHEN '2' THEN 'nd' 
                            WHEN '3' THEN 'rd' ELSE 'th' END END),
            day_name,
            day_of_week,
            day_of_week_in_month = CONVERT(tinyint, ROW_NUMBER() OVER 
                            (PARTITION BY first_of_month, day_of_week ORDER BY [date])),
            day_of_year,
            is_weekend           = CASE WHEN day_of_week IN (1, 7) THEN 1 ELSE 0 END,
            week,
            [iso_week],
            first_of_week      = DATEADD(DAY, 1 - day_of_week, [date]),
            last_of_week       = DATEADD(DAY, 6, DATEADD(DAY, 1 - day_of_week, [date])),
            week_of_month      = CONVERT(tinyint, DENSE_RANK() OVER 
                            (PARTITION BY year, month ORDER BY week)),
            month,
            month_name,
            first_of_month,
            last_of_month      = MAX([date]) OVER (PARTITION BY year, month),
            first_of_next_month = DATEADD(MONTH, 1, first_of_month),
            last_of_next_month  = DATEADD(DAY, -1, DATEADD(MONTH, 2, first_of_month)),
            quarter,
            first_of_quarter   = MIN([date]) OVER (PARTITION BY year, quarter),
            last_of_quarter    = MAX([date]) OVER (PARTITION BY year, quarter),
            year,
            iso_year          = year - CASE WHEN month = 1 AND [iso_week] > 51 THEN 1 
                            WHEN month = 12 AND [iso_week] = 1  THEN -1 ELSE 0 END,
            first_of_year      = DATEFROMPARTS(year, 1,  1),
            last_of_year,
            is_leap_year          = CONVERT(bit, CASE WHEN (year % 400 = 0)
                OR (year % 4 = 0 AND year % 100 <> 0) 
                            THEN 1 ELSE 0 END),
            has_53_weeks          = CASE WHEN DATEPART(WEEK,     last_of_year) = 53 THEN 1 ELSE 0 END,
            has_53_iso_weeks       = CASE WHEN DATEPART(ISO_WEEK, last_of_year) = 53 THEN 1 ELSE 0 END,
            mm_yyyy              = CONVERT(char(2), CONVERT(char(8), [date], 101))
                          + '-' + CONVERT(char(4), year)
        FROM src
    )
SELECT *
INTO calendar
FROM dim
ORDER BY [date]
OPTION
(MAXRECURSION
0);


```



## Naming conventions for constraints
https://stackoverflow.com/questions/4836391/naming-convention-for-unique-constraint
<table>
<thead style="background: lightgrey">
<tr>
<th style="text-align: center;">Suffix</th>
<th style="text-align: left;">Meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: center;"><code>PK</code></td>
<td style="text-align: left;"><strong>P</strong>rimary <strong>K</strong>ey</td>
</tr>
<tr>
<td style="text-align: center;"><code>AK</code></td>
<td style="text-align: left;"><strong>A</strong>lternate <strong>K</strong>ey</td>
</tr>
<tr>
<td style="text-align: center;"><code>FK</code></td>
<td style="text-align: left;"><strong>F</strong>oreign <strong>K</strong>ey</td>
</tr>
<tr>
<td style="text-align: center;"><code>IX</code></td>
<td style="text-align: left;"><strong>I</strong>nde<strong>X</strong></td>
</tr>
<tr>
<td style="text-align: center;"><code>CK</code></td>
<td style="text-align: left;"><strong>C</strong>hec<strong>K</strong></td>
</tr>
<tr>
<td style="text-align: center;"><code>DF</code></td>
<td style="text-align: left;"><strong>D</strong>e<strong>F</strong>ault</td>
</tr>
</tbody>
</table>