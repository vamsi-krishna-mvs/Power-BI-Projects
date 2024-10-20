

create table pizza_sales(
	pizza_id int,
	order_id int,
	pizza_name_id varchar,
	quantity int,
	order_date date,
	order_time time,
	unit_price decimal,
	total_price decimal,
	pizza_size varchar,
	pizza_category varchar,
	pizza_ingredients varchar,
	pizza_name varchar)


	
truncate table pizza_sales

	
drop table pizza_sales

	
select * from pizza_sales


select order_date::date
	from pizza_sales
	
copy pizza_sales from 'D:\power BI\Project\dt\pizza_sales.csv' delimiter ',' csv header;


select pg_typeof(order_date) from pizza_sales



-- 1. Total Revenue:

select round(sum(total_price),2) as  Total_Revenue
from pizza_sales; 


-- 2 , 4
with cte as (
select count( distinct order_id) as distinct_orders
from pizza_sales)
select  round( (sum(total_price)/(select * from cte)) ,2)
from pizza_sales;


--2. Average Order Value

select  round( sum(total_price) / (select count(distinct order_id) from pizza_sales ) ,2) as avg_order_val
from pizza_sales;

-- 3. Total Pizzas Sold

select sum(quantity) as total_pizzas_sold
from pizza_sales;


-- 4. Total Orders

select count( distinct order_id) as total_orders
from pizza_sales

	
-- 5


select  round( sum(quantity) / (select count(distinct order_id) from pizza_sales ),2 ) as avg_pizzas_per_order
from pizza_sales;



-- b,c

select to_char(order_date,'day'),count(distinct order_id)
from pizza_sales
group by 1
order by 2 desc


select to_char(order_date,'month'),count(distinct order_id)
from pizza_sales
group by 1
order by 2 desc


-- def

select pizza_category,sum(total_price) as total_revenue,
		round((sum(total_price)*100 / (select sum(total_price) from pizza_sales)),2) as percentage
from pizza_sales
group by 1
order by 3 desc


select pizza_size,sum(total_price) as total_revenue,
		round((sum(total_price)*100 / (select sum(total_price) from pizza_sales)),2) as percentage
from pizza_sales
group by 1
order by 3 desc



select pizza_category, sum( quantity) as total_pizzas,
	round((sum( quantity)*100 / (select  sum( quantity) from pizza_sales)),3) as percentage
from pizza_sales
group by 1
order by 2 desc


-- ghijkl


select pizza_name,sum(total_price) as revenue
from pizza_sales
group by pizza_name
order by 2 desc
limit 5


select pizza_name,sum(total_price) as revenue
from pizza_sales
group by pizza_name
order by 2 
limit 5


select pizza_name,sum(quantity) as total_pizzas
from pizza_sales
group by pizza_name
order by 2
limit 5


select pizza_name,sum(quantity) as total_pizzas
from pizza_sales
group by pizza_name
order by 2 desc
limit 5


select pizza_name,count( distinct order_id) as total_orders
from pizza_sales
group by pizza_name
order by 2 desc
limit 5


select pizza_name,count( distinct order_id) as total_orders
from pizza_sales
group by pizza_name
order by 2
limit 5