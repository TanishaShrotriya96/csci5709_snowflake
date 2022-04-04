USE DATABASE goingDataWay_sales;
USE SCHEMA curated;

CREATE OR REPLACE VIEW customer_monthly_sales_2019_view AS 
SELECT  s.customerid, 
        c.lastname, 
        c.firstname, 
        YEAR(s.date) as year, 
        MONTH(s.date) as month,
        SUM(p.price * s.quantity) as totalsales
FROM    sales s, customers c, products p
WHERE   s.customerid = c.customerid
    AND s.productid = p.productid
    AND YEAR = 2019
GROUP BY s.customerid, c.lastname, c.firstname, year, month;    
