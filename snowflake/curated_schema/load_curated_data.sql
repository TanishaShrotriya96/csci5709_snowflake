USE DATABASE goingDataWay_sales;
USE SCHEMA curated;

create or replace file format sales_csv_format
    type = 'CSV'
    field_delimiter = '|'
    skip_header = 1;

create or replace stage sales_stage
    url = 's3://seng5709/'
    file_format = sales_csv_format;

list @sales_stage;

copy into customers
    from @sales_stage/customers/
    pattern='.*Customers.*.csv'
    on_error = 'skip_file';

copy into products
    from @sales_stage/products/
    pattern='.*Products.*.csv'
    on_error = 'skip_file';

copy into sales
    from @sales_stage/sales/
    pattern='.*Sales.*.csv'
    on_error = 'skip_file';

create or replace file format employee_csv_format
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1;

create or replace stage employees_stage
    url = 's3://seng5709/'
    file_format = employee_csv_format;

copy into employees
    from @employees_stage/employees/
    pattern='.*Employees.*.csv'
    on_error = 'continue';

update customers
    set customers.MiddleInitial = LOWER(customers.MiddleInitial);

update employees
    set employees.region = LOWER(employees.region);

alter table sales rename column SalesPersonID to EmployeeID;



