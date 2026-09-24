
# Power BI

## RLS

### Considerations
> The UseRelationship() and CrossFilter() functions may not be used when querying '<oii>production_product_eom_reserve</oii>' because it is constrained by row-level security.

## Deprecated

### Tables
```
calendar_product_daily_total_tonnes = 
// This table is necessary as the production_daily_total_tonnes
// doesn't contain a record for each date/(site_id, plant_id) combination.
ADDCOLUMNS(
    CROSSJOIN(
        FILTER(
            SUMMARIZE(
                plant_daily_total_tonnes,
                ROLLUP(
                    plant_daily_total_tonnes[site_id],
                    plant_daily_total_tonnes[plant_id]
                )
            ),
            [plant_id] <> BLANK()
        ), 
        SELECTCOLUMNS('calendar', "date", [date])
    ),
    "amount", IF(LOOKUPVALUE('calendar'[is_weekend],'calendar'[date], [date]) = 1,0, LOOKUPVALUE(plants_plant[target_tonnes], plants_plant[site_id], [site_id],plants_plant[plant_id], [plant_id])),
    "site_plant_key", [site_id] & "_" & [plant_id]
)
```

```
plant_daily_targets = 
var PlantTargetRates = SELECTCOLUMNS(
    FILTER(
        plants_plant, 'plants_plant'[target_tonnes] <> BLANK()
    ),
    "site_id", [site_id],
    "plant_id", [plant_id],
    "site_plant_key", [site_id] & "_" & [plant_id],
    "target_tonnes", [target_tonnes]
)
var CurrentYearDates = SELECTCOLUMNS(
    'calendar',
    "date",
    [date]
)
var DailyTargetRates = CROSSJOIN(PlantTargetRates, CurrentYearDates)
var WeekendAdjustedDailyTargetRates = ADDCOLUMNS(DailyTargetRates, "weekend_adjusted_target_tonnes", If(LOOKUPVALUE('calendar'[is_weekend],'calendar'[date], [date]) = 1, 0, [target_tonnes]))
var Result = SELECTCOLUMNS(WeekendAdjustedDailyTargetRates, "date", [date], "site_id", [site_id], "plant_id", [plant_id], "site_plant_key", [site_plant_key], "target_tonnes", [weekend_adjusted_target_tonnes])
return Result
```

### Calculated Columns
```
Prior Month Movement = If(production_product_eom_reserve[amount] - production_product_eom_reserve[Prior Amount] > 0
    ,1
    ,If (production_product_eom_reserve[amount] - production_product_eom_reserve[Prior Amount] < 0,
        -1,
        0
    )
)
```
```
Prior Amount = LOOKUPVALUE(production_product_eom_reserve[amount],production_product_eom_reserve[Key], production_product_eom_reserve[product_id] & "_" & FORMAT(LASTDATE(PREVIOUSMONTH('calendar'[date])), "yyyy-mm-dd"))
```
```
Status = If(production_product_eom_reserve[amount] - production_product_eom_reserve[Prior Amount] > 0
    ,UNICHAR(9650) // Green dot = UNICHAR(128994)
    ,If (production_product_eom_reserve[amount] - production_product_eom_reserve[Prior Amount] < 0,
        UNICHAR(9660),// Red dot UNICHAR(128308),
        BLANK()// Yellow dot = UNICHAR(128993)
    )
)
```