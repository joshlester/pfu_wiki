
## Configure Plant for OEE

In order for a plant to appear on the OEE report page its production (tonnes, operation hours, rate) must be captured in the `plants_plant_measure_daily` table.
<br>

### Configure Manual Plant
* Plants with a `MANUAL` production source must have a entry in the `plants_plant_setting` table with a `key` of `PRODUCTION_ENTRY_TO_DAILY_MEASURE` and a value of `true`

* A `PRODUCTION_HOURS` trait must be added to the `plants_plant_trait` trait table.

* By default, all product tonnes are included in the daily tonnes total.  
However, you can specify which products contribute to this total by adding an entry to the `plants_plant_expression` table with:
	- a `key` of `TONNES_TOTAL_DAILY`
	- an **`expression`** that defines the specific products to be captured

### Add Plant with Yield Configuration

- Add record to `plants_plant_data_source`. This table specifies where the production data e.g. tonnes, production hours etc. is source from e.g. Tamaki Control API.

- `plants_plant_measure` capture the measure data which should be used to source data from connector (external API).

- `plants_plant_measure_product_map` - Map a plant measure to a specific product

