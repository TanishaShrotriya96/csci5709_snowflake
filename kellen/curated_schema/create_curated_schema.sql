use DATABASE goingDataWay_sales;

create or replace SCHEMA curated;

create or replace TABLE employees
(
    EmployeeID      integer PRIMARY KEY,
    FirstName       varchar(50),
    MiddleInitial   varchar(50),
    LastName        varchar(50),
    Region          varchar(100)
);

create or replace TABLE customers
(
    CustomerID      integer PRIMARY KEY,
    FirstName       varchar(50),
    MiddleInitial   varchar(50),
    LastName        varchar(50)
);

create or replace TABLE products
(
    ProductID   integer PRIMARY KEY,
    Name        varchar(50),
    Price       decimal(38, 5)
);

create or replace TABLE sales
(
    OrderID         integer PRIMARY KEY,
    SalesPersonID   integer references employees(EmployeeID),
    CustomerID      integer references customers(CustomerID),
    ProductID       integer references products(ProductID),
    Quantity        integer,
    Date        timestamp
);