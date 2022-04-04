USE DATABASE goingDataWay_sales;
USE SCHEMA raw;

create or replace stage sales_stage
    url = 's3://seng5709/';

list @sales_stage;

copy into customers
    from @sales_stage/customers/
    pattern='.*Customers[1-9]*.csv'
    on_error = 'skip_file';

copy into employees
    from @sales_stage/employees/
    pattern='.*Employees[1-9]*.csv'
    on_error = 'continue';

copy into products
    from @sales_stage/products/
    pattern='.*Products[1-9]*.csv'
    on_error = 'skip_file';

copy into sales
    from @sales_stage/sales/
    pattern='.*Sales[1-9]*.csv'
    on_error = 'skip_file';