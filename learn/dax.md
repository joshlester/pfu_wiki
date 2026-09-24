
# Learn DAX

## Cheatsheet

https://www.youtube.com/watch?v=NbbE39gwVVo&ab_channel=SQLBI
> My understanding is that SalesPerCustomer is actual the total sales amount divided by the distinct customer count. This could them be filters to show the total sales for each customer.
```
SalesPerCustomer = 
DIVIDE (
	SUMX ( Sales, Sales[Quantity] * Sales[Net Price]),
  DISTINCTCOUNT ( Sales[CustomerKey] )
 )
```
better version
```
SalesPerCustomer =

VAR SalesAmount =
	SUMX ( Sales, Sales[Quantity] * Sales[Net Price] )

VAR NumSales =
	DISTINCTCOUNT ( Sales[CustomerKey] )
  
RETURN 
	DIVIDE (
  	SalesAmount,
    NumCustomer
   )

```

https://www.youtube.com/watch?v=NbbE39gwVVo&ab_channel=SQLBI
> The the total value of the top 10 products by sales amount
```
Best Product Sales = 
VAR BestProducts = TOPN ( 10, 'Product', [Sales Amount] )
VAR SalesOfBestProducts =
SUMX (
	BestProducts,
  SUMX (
  	RELATEDTABLE ( Sales ),
    // Would be nice to be able to reference that VAR
    // BestProducts but not currently possible, must ref
    // the base table which BestProducts is derived from
    Sales[Quantity] * 'Product'[Unit Price] 
	)
)
```
https://www.youtube.com/watch?v=NbbE39gwVVo&ab_channel=SQLBI
> Percent of sales
```
Pct = 
DIVIDE (
	SUMX ( Sales[Quantity] * Sales[Net Amount] ),
  CALCULATE (
  	SUMX ( Sales[Quantity] * Sales[Net Amount] ),
    REMOVEFILTERS ( Sales )
  )
)
```

## Functions

### USERELATIONSHIP
Override the **active** relationship for the duration of the calculation e.g.
<span style="color:#888; font-style:italic">Used when there is more than one relationship i.e. active vs. inactive between two tables.</span>
```
= CALCULATE(SUM(InternetSales[SalesAmount]), USERELATIONSHIP(InternetSales[ShippingDate], DateTime[Date]))
```