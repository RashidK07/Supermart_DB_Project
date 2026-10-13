select * from customer;
select * from product;
select * from sales;

-- 1. Sales Performance by Region --

select c.region, sum(s.sales) as total_sales from customer as c join 
sales as s on c.customer_id=s.customer_id group by 1 order by 2 desc; 


-- 2. Top-Selling Products --

select p.product_name, sum(s.sales) as total_sales from product as p inner join 
sales as s on p.product_id=s.product_id group by 1 order by 2 desc limit 10;


-- 3. Discount Impact on Profit --

select discount, avg(profit) as avg_profit from sales group by 1 order by 1;


-- 4. Sales by Customer Segment --

select c.segment, sum(s.sales) from customer as c join sales as s
on c.customer_id=s.customer_id group by 1 order by 2 desc; 


-- 5. Product Category Sales --

select p.category, sum(s.sales) as total_sales from product as p join 
sales as s on p.product_id=s.product_id group by 1 order by 2 desc;


-- 6. Customer Orders by Ship Mode --

select ship_mode, count(order_line) as total_orders from sales
group by 1 order by 2 desc;


-- 7. Sales by Date --

select extract(year from order_date) as year, extract(month from order_date) as month,
sum(sales) as total_sales from sales group by 1,2 order by 1,2;


-- 8. Customer Distribution by State --

select state, count(customer_id) as total_customers from customer 
group by 1 order by 2 desc;


-- 9. Top 5 Customers by Sales --

select c.customer_name, sum(s.sales) as total_sales from customer as c join 
sales as s on c.customer_id=s.customer_id group by 1 order by 2 desc limit 5;


-- 10. Product Performance in Subcategories --

select p.sub_category, sum(s.sales) as total_sales from product as p inner join 
sales as s on p.product_id=s.product_id group by 1 order by 2 desc;


-- 11. Rank Products by Sales --

select p.category, p.product_name, sum(s.sales) as total_sales, 
rank() over(partition by p.category order by sum(s.sales) desc) as ranks
from product as p join sales as s on p.product_id=s.product_id 
group by p.category, p.product_name order by p.category, ranks;


-- 12. Cumulative Sales by Date --

select p.product_id, p.product_name, s.order_date, floor(s.sales) as t_sales, 
sum(floor(s.sales)) over(order by s.order_date) as c_sales 
from product as p join sales as s on p.product_id=s.product_id order by 3;


-- 13. Find Top 3 Customers by Profit --    

select * from (
select c.customer_id, c.customer_name, c.region, sum(s.profit) as total_profit, 
rank() over(partition by c.region order by sum(s.profit) desc) as ranks from customer as c 
join sales as s on c.customer_id=s.customer_id group by 1,2,3) as cust_profit where ranks<=3;


-- 14. Average Sales by Segment with Row Number --

select c.customer_name, c.segment, sum(s.sales) as total_sales, avg(sum(s.sales)) over(partition by c.segment) 
as average_sales, row_number() over(partition by c.segment order by sum(s.sales) desc) as rows
from customer as c join sales as s on c.customer_id=s.customer_id group by 1,2 order by 4,5;


-- 15. Difference in Sales Between Consecutive Days --

select p.product_name, s.order_date, floor(sum(s.sales)) as total_sales, 
lag(floor(sum(s.sales)),1,0) over(partition by p.product_name order by s.order_date) as prev_day_sales, 
floor(sum(s.sales)) - lag(floor(sum(s.sales)),1,0) over(partition by p.product_name order by s.order_date) as difference 
from product as p join sales as s on p.product_id=s.product_id group by 1,2 order by 1,2;


-- 16. Find Percent of Total Sales by Region --

select c.region, floor(sum(s.sales)) as salesbyregion, (sum(s.sales * 100)/ sum(sum(s.sales)) over()) as percentage 
from customer as c join sales as s on c.customer_id=s.customer_id group by 1 order by 2 desc;


-- 17. Calculate Moving Average of Sales --

select p.product_name, s.order_date, floor(s.sales), (avg(floor(s.sales)) over(partition by p.product_name 
order by s.order_date rows between 2 preceding and current row)) as avg_sales from product as p 
join sales as s on p.product_id=s.product_id;


-- 18. Find Largest and Smallest Order by Customer --

select distinct c.customer_name, max(s.sales) over(partition by c.customer_name) as max_sales, 
min(s.sales) over(partition by c.customer_name) as min_sales from customer as c join 
sales as s on c.customer_id=s.customer_id order by 1;


-- 19. Running Total of Profit by Customer --

select c.customer_name, s.order_date, s.profit as total_profit, 
sum(s.profit) over(partition by c.customer_name order by s.order_date) as running_profit 
from customer as c join sales as s on c.customer_id=s.customer_id;


-- 20. Calculate Dense Rank of Sales by Ship Mode --

select ship_mode, sales, dense_rank() 
over(partition by ship_mode order by sales desc) as ranks from sales;
























