
# Queries

Select Visit count and Net Tonnes 
```SQL
-- SELECT CAST(wvv.out_visit_dt AS DATE) AS [date], COUNT(wvv.visit_id)  --SUM(net_weight) / 1000 as 'net_tonnes', count(wvvvm.visit_vehicle_material_id)
SELECT SUM(net_weight) / 1000 as 'net_tonnes', count(wvvvm.visit_vehicle_material_id)
FROM weightrax_visits_visit wvv
inner join weightrax_visits_visit_vehicle wvvv ON (wvv.visit_id = wvvv.visit_id)
inner JOIN weightrax_visits_visit_vehicle_material wvvvm ON (wvvv.visit_vehicle_id = wvvvm.visit_vehicle_id)
where wvvvm.material_desc  LIKE '%RWB%'
and wvv.out_visit_dt  >= '2022-10-01'
and wvv.out_visit_dt  < '2022-11-01'
and wvv.void_dt IS NULL
--GROUP BY CAST(wvv.out_visit_dt AS DATE)
```
