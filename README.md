
## Project 2: Snowflake
### Team: Going Data Way
### Authors: Sravani Kirla, Kellen Mulford, Ivan Radkevich, Tanisha Shrotirya, Trevor Winger
### CSCI 5709: Big Data Engineering, Spring 2022
---
### Deliverable  2
#### Step 1

The team wrote two scripts that accomplish the tasks in step 1. The first script creates the database, schema, and tables. The second script creates an external stage for the S3 data, and then loads the data into the tables created in script 1. One tricky component is that several of the raw csv files were delimited with `|` but one was delimited with `,`. Snowflake documentation suggests defining a file format to ensure clean data entry. However, instead of defining several file formats to handle the different delimiters which would have required setting up multiple stages the team simply let Snowflake decide the delimiter. 

| Order | Name of File | Path | Description |
|-------|--------------|------|-------------|
|1|`create_raw_schema.sql`|`snowflake/raw_schema/create_raw_schema.sql`|Creates DB, schema, and tables|
|2|`load_raw_data.sql`|`snowflake/raw_schema/load_raw_data.sql`|Creates external stage, loads data into DB|

---
### Step 2
#### Data Issues

The team found a few small issues in the data.

1. In the `Employees` table:    
    a. The middle initials are all lower case. In the `Customers` table the middle initials are all upper case.  
    b. Inconsistent lower/upper cases in the region names.  
    c. The middle initial for employee id 15 is an apostrophe, and their last name has been written as O'Leary.  
2. In the `Customers` table:        
    a. See issue "a." in the Employees table section.   
3. In the `Products` table:     
    a. The price for a number of products is 0. Also, despite creating the `products` column with type decimal when previewing the data in snowflake the numbers have all been truncated. Kellen's time spent working in a bike shop tipped him off that this is a catalog of bike parts. It is highly unlikely that any wholesale bike part vendor is giving out headset ball bearings for free.    
4. In the `Sales` table:    
    a. There are a number of items in the product catalog with price $0. Around 10% of sales were with products with a price of $0. These may be fraudulent sales. The employee with ID 17 has the most of these sales, with a total of 56710.    
    b. The column `salespersonID` might be renamed `employeeID` to match the `employees` table. 
    c.  A large number of individual sales have the same value in the columns productID and quantity (that is, for these rows `productid=quantity`). The most likely explanation for this is that it is synthetic data, as it seems abnormally coincidental.

#### Correcting Data Issues

The team wrote two scripts to create the `curated` schema and correct for issues 1b (using the `LOWER` function), 2a (also using `LOWER`), 3a (by specifying precision), 4a (with the `ALTER TABLE` syntax). The team could have changed the initial employees middle initials to uppercase, but in general text work is easier in lower case as upper case carries connotation in the english language. The team did not fix 4c, the data is what it is. The team did not fix 1c either because it is probably wiser to check with the employee before making any changes to provided data.

| Order | Name of File | Path | Description |
|-------|--------------|------|-------------|
|1|`create_curated_schema.sql`|`snowflake/curated_schema/create_curated_schema.sql`|Creates DB, schema, and corrected tables|
|2|`load_curated_data.sql`|`snowflake/curated_schema/load_curated_data.sql`|Creates external stage, loads data into DB, also fixes case issue and column name parity|

#### Views

| Order | Name of File | Path | Description |
|-------|--------------|------|-------------|
|1|`customer_monthly_sales_2019_view.sql`|`snowflake/views/customer_monthly_sales_2019_view.sql`|Displays purchase amounts for each customer by month in 2019|
|2|`top_ten_customers_amount_view.sql`|`snowflake/views/top_ten_customers_amount_view.sql`|Displays top 10 customers with highest lifetime purchase amounts|
|3|`product_sales_view.sql`|`snowflake/views/product_sales_view.sql`|Displays information for indidividual sales|

---
### Deliverable 3

#### Materialized Views and Clustering

Materialized views are a subset of the table that is precomputed based on a `SELECT` statement and stored for future use. They are a good idea when a single query is run very frequently or is computationally expensive. Two specific use cases with respect to the sales data are:

1. Keeping track of aggregated sales volumes for past years could be useful for developing forecasting models of sales. This is a good candidate for a materialized view because at the end of a year, the subset of the sales table containing data for this year will never change (unless the company has a lifetime warranty). This query requires significant aggregations and produces a small amount of rows relative to the overall sales table. Thus, creating a materialized view for it could reduce table scanning and computational resource use for the analysts tasked with creating sales reports.
2. Complicated queries with multiple joins use a large amount of computational resources, especially if they are rerun repeatedly. For example, suppose the company wanted to keep track of which employees produce sales to certain customers. This would require joins between the employee and a subset of the sales table, then between sales subset and customers, followed by some aggregations. While employees table is small in size and the first join seems more doable, the customers table will increase query complexity and runtime. In particular, Snowflake's materialized views are optimized for queries which repeatedly produce the same subset of rows. For eg, employees are likely to sell to the same customers over time and due to geographic restraints. A materialized view would be more optimal than performing the query on the original tables.

#### Deletion script
| Order | Name of File | Path | Description |
|-------|--------------|------|-------------|
|1|`drop_everything.sql`|`snowflake/drop_everything.sql`|Drops the "goindDataWay_Sales database and all accompanying Schemas, Tables, Views etc.|

---

### Appendix: Complete script table

| Order | Name of File | Path | Description |
|-------|--------------|------|-------------|
|1|`create_raw_schema.sql`|`snowflake/raw_schema/create_raw_schema.sql`|Creates DB, schema, and tables|
|2|`load_raw_data.sql`|`snowflake/raw_schema/create_raw_stage.sql`|Creates external stage, loads data into DB|
|3|`create_curated_schema.sql`|`snowflake/curated_schema/create_curated_schema.sql`|Creates DB, schema, and corrected tables|
|4|`load_curated_data.sql`|`snowflake/curated_schema/load_curated_data.sql`|Creates external stage, loads data into DB, also fixes case issue and column name parity|
|6|`customer_monthly_sales_2019_view.sql`|`snowflake/views/customer_monthly_sales_2019_view.sql`|Displays purchase amounts for each customer by month in 2019|
|7|`top_ten_customers_amount_view.sql`|`snowflake/views/top_ten_customers_amount_view.sql`|Displays top 10 customers with highest lifetime purchase amounts|
|8|`product_sales_view.sql`|`snowflake/views/product_sales_view.sql`|Displays information for indidividual sales|
|9|`drop_everything.sql`|`snowflake/drop_everything.sql`|Drops the "goindDataWay_Sales database and all accompanying Schemas, Tables, Views etc.|
