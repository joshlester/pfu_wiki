
# Power BI

## Calculated columns

### Movement (day)
Removed as measure used instead
```
Movement (day) = 

VAR SymbolExchange = [Symbol Exchange]
VAR PrevDay = PREVIOUSDAY('calendars_calendar'[cdate])
VAR CurrentPrice = [price]

RETURN
    MAXX(
            FILTER(
                stocks_stock_tick_daily,
                AND(
                    stocks_stock_tick_daily[Symbol Exchange] = SymbolExchange,
                    stocks_stock_tick_daily[Created On (date)] = PrevDay
                )
            ),
        DIVIDE(CurrentPrice - [price], [price], BLANK()) 
    )
```
