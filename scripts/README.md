## Project 2: Snowflake
### Author: Kellen Mulford, Team: Going Data Way
### CSCI 5715: Big Data Engineering, Spring 2022
---
#### Deliverable 2

I wrote two scripts that accomplish the tasks in deliverable 2. The first script creates the database, schema, and tables. The second script creates an external stage for the S3 data, and then loads the data into the tables created in script 1. One tricky component is that several of the raw csv files were delimited with `|` but one was delimited with `,`. Snowflake documentation suggests defining a file format to ensure clean data entry. However, instead of defining several file formats to handle the different delimiters which would have I think required setting up multiple stages I simply let Snowflake decide the delimiter. 

| Order | Name of File | Path | Description |
|-------|--------------|------|-------------|
|1|`create_db_schema.sql`|`snowflake/create_db_schema.sql`|Creates DB, schema, and tables|
|2|`create_stage.sql`|`snowflake/create_stage.sql`|Creates external stage, loads data into DB|

---
#### Data Issues

I found a few small issues in the data.

1. In the `Employees` table:
    a. The middle initials are all lower case. In the `Customers` table the middle initials are all upper case.
    b. Inconsistent lower/upper cases in the region names
2. In the `Customers` table:
    a. See issue "a." in the Employees table section.
3. In the `Products` table:
    a. The price for a number of products is 0. Also it looks like despite me creating the `products` column with type decimal when I preview the data in snowflake the numbers have all been truncated. My time spent working in a bike shop tipped me off that this is a catalog of bike parts, there is no way any local shop owner is giving out headset ball bearings for free.
4. In the `Sales` table:
    a. The column `salespersonID` might be renamed `employeeID` to match the `employees` table.
    b.  A large number of sales have the same productID and quantity. It looks like this is what is in the raw csv on S3 but it seems fishy to me. To break the educational 4th wall, this might just be because it is likely synthetic data.