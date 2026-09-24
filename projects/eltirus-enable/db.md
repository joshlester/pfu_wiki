
# Database
<br>

## dbdiagram.io scheme
```
Table clients_client {
  id int [pk]
  client_id nvarchar [not null, unique, ref: < _client_site.client_id]
  client_name nvarchar
  created_on datetime2 [default: `now()`]
}

// Ref: order_items.product_id > products.id

Table sites_site {
  id int [pk] // primary key
  site_id int [
    not null, unique,
    ref: - _client_site.site_id,
    ref: < _site_plant.site_id
  ]

  site_name nvarchar
  created_on datetime2 [default: `now()`]
}

Table _client_site {
  id int [pk]
  client_id nvarchar
  site_id nvarchar
  created_on datetime2 [default: `now()`]
  
    Indexes {
    (client_id, site_id) [name:'udx_client_site', unique]
  }
}

Table plants_plant {
  id int [pk] // primary key
  plant_id int [not null, unique, ref: < _site_plant.plant_id]
  plant_name nvarchar
  created_on datetime2 [default: `now()`]
}

Table _site_plant {
  id int [pk]
  site_id nvarchar
  plant_id nvarchar
  created_on datetime2 [default: `now()`]
}

Table products_product {
  id int [pk] // primary key
  product_id int [not null, unique ]
  name nvarchar
  created_on datetime2 [default: `now()`]
  site_plant_id nvarchar [ref: - _site_plant.id]
}

Table _site_product {
  id int [pk] // primary key
  site_id nvarchar [not null, ref: < sites_site.site_id]
  product_id nvarchar [not null, ref: < products_product.product_id]
  created_on datetime2 [default: `now()`]
}

Table measures_measure {
  id int [pk] // primary key
  measure_id int 
  name varchar [not null]
  created_on datetime2 [default: `now()`]
}

Table _client_measure {
  id int [pk] // primary key
  client_id nvarchar [ref: < clients_client.client_id]
  measure_id nvarchar [ref: < measures_measure.measure_id]
  created_on datetime2 [default: `now()`]
}

Table productions_entry {
  id bigint [pk]
  created_on datetime2 [default: `now()`]
  
}

Table productions_entry_measure {
  id bigint [pk]
  entry_id bigint [ref: < productions_entry.id]
  measure_id nvarchar [ref: < _client_measure.id]
  created_on datetime2 [default: `now()`]
  value float [not null]
}

Table productions_entry_product {
  id int [pk]
  entry_id bigint [ref: < productions_entry.id]
  site_product_id int [not null, ref: < _site_product.id]
  created_on datetime2 [default: `now()`]
  tonnes float [not null]
}

Table productions_entry_source {
  id int [pk] // primary key
  entry_id bigint [ref: < productions_entry.id]
  sourced_from nvarchar [not null]
  note nvarchar 
  created_on datetime2 [default: `now()`]
}

//----------------------------------------------//

//// -- Level 3 
//// -- Enum, Indexes

// Enum for 'products' table below
// Enum products_status {
//   out_of_stock
//   in_stock
//   running_low [note: 'less than 20'] // add column note
// }

// // Indexes: You can define a single or multi-column index 
// Table products {
//   id int [pk]
//   name varchar
//   merchant_id int [not null]
//   price int
//   status products_status
//   created_at datetime [default: `now()`]
  
//   Indexes {
//     (merchant_id, status) [name:'product_status']
//     id [unique]
//   }
// }

// Table merchants {
//   id int
//   country_code int
//   merchant_name varchar
  
//   "created at" varchar
//   admin_id int [ref: > U.id]
//   Indexes {
//     (id, country_code) [pk]
//   }
// }

// Table merchant_periods {
//   id int [pk]
//   merchant_id int
//   country_code int
//   start_date datetime
//   end_date datetime
// }

// Ref: products.merchant_id > merchants.id // many-to-one
// //composite foreign key
// Ref: merchant_periods.(merchant_id, country_code) > merchants.(id, country_code)
```
