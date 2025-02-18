use walmart_db;
select * from walmart
-- Drop table walmart

select count(*) from walmart

select distinct payment_method from walmart;

select payment_method , count(*) from walmart group by payment_method

select count(distinct branch) from walmart;

select min(quantity) from walmart;

-- Business problem

-- 1. Find different payment method and the number of transaction, number of qty sold

select payment_method , count(*)as no_payments, 
sum(quantity)as no_qty_sold 
from walmart
group by payment_method

-- 2. idenfity the highest-rated category in each  branch, displaying the branch, category avg rating

SELECT * 
FROM (
    SELECT branch, 
           category, 
           AVG(rating) AS avg_rating, 
           RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS `rank` 
    FROM walmart 
    GROUP BY branch, category
) AS subquery
WHERE `rank` = 1;


-- 3.identify the busiest day for each branch based on the number of transcation

SELECT * 
FROM (
    SELECT branch, 
           DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name, 
           COUNT(*) AS no_transactions, 
           RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS `rank` 
    FROM walmart  
    GROUP BY branch, category, day_name
) AS subquery
WHERE `rank` = 1;


-- 4. calculate the total quantity of items sold per payment method. list payment_method 

select
    payment_method, 
    sum(quantity) as no_qty_sold 
from walmart
group by payment_method

-- 5. Determine the average, minimum, and maximum rating of product for each city. 
-- List the city, average_rating, min_rating, and max_rating.

select 
    city,
    category,
    min(rating) as min_rating,
    max(rating) as max_rating,
    avg(rating) as avg_rating
from walmart
group by 1,2

-- 6. calculate the total profit for each category by considering total_profit as 
-- (unit_price * quantity * profit_margin)
-- list category and total_profit, ordered from higest to lowest profit.

select 
 category,
 sum(total) as total_revenue,
 sum(total * profit_margin) as profit 
from walmart
group by 1 

-- 7. Determine the most common payment method for each branch, display branch and the preferred_payment_method.
WITH cte AS (
    SELECT branch, 
           payment_method, 
           COUNT(*) AS total_trans, 
           RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS `rank` 
    FROM walmart 
    GROUP BY 1 ,2
) 
SELECT *  
FROM cte 
WHERE `rank` = 1;

-- 8. categorize sales into 3 group morning, evening 
-- find out which of the shift and number of invoices 
SELECT 
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift, 
    COUNT(DISTINCT invoice_id) AS number_of_invoices
FROM walmart
GROUP BY shift
ORDER BY number_of_invoices DESC;

-- 9. identify 5 branch with hightest decrease ratio in 
-- revenue compare to last year(current year 2023 and last year 2022

-- rdr == last_rev_cr_rev/ls_rev*100






