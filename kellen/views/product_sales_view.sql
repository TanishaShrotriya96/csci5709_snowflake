USE DATABASE goingDataWay_sales;
USE SCHEMA curated;

CREATE OR REPLACE VIEW product_sales_view AS
SELECT  s.orderid,
        s.employeeid,
        s.customerid,
        s.productid,
        p.name,
        p.price,
        s.quantity,
        p.price * s.quantity as total_sales_amount,
        s.date as order_date,
        YEAR(s.date) as order_year,
        MONTH(s.date) as order_month
from sales s, products p
WHERE s.productid = p.productid;
