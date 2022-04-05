USE DATABASE goingDataWay_sales;
USE SCHEMA curated;

CREATE or REPLACE VIEW top_ten_customers_amount_view AS
SELECT  s.customerid,
        c.lastname,
        c.firstname,
        SUM(p.price * s.quantity) as totallifetimeamount
FROM    sales s, customers c, products p
WHERE   s.customerid = c.customerid
    AND s.productid = p.productid
GROUP BY s.customerid, c.lastname, c.firstname
ORDER BY totallifetimeamount DESC
LIMIT 10;