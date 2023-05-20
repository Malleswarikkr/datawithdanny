-1.-How many runners signed up for each 1 week period?
Ans:select count(runner_id), date_trunc('week',registration_date)+ INTERVAL '4 days' as week from pizza_runner.runners group by 
date_trunc('week',registration_date)+ INTERVAL '4 days'

-2.-What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
with a as(select runner_id, pickup_time::timestamp without time zone,order_time, pickup_time::timestamp without time zone-order_time as difference from 
pizza_runner.runner_orders as ro inner join pizza_runner.customer_orders as co on ro.order_id=co.order_id where pickup_time<>'null')select runner_id,avg(difference) from a 
group by runner_id

3.--Is there any relationship between the number of pizzas and how long the order takes to prepare?
with a as (select co.order_id,count(pizza_id) as num_of_pizzas, max(pickup_time::timestamp without time zone-order_time) as diff from 
pizza_runner.runner_orders as ro inner join pizza_runner.customer_orders as co on ro.order_id=co.order_id where pickup_time<>'null'  group by co.order_id)
select num_of_pizzas,avg(diff) from a group by num_of_pizzas

4.--What was the average distance travelled for each customer?
with a as(select replace(distance,'km','')::numeric(3,1) as distance1,*  from pizza_runner.customer_orders as co inner join pizza_runner.runner_orders as ro on 
co.order_id=ro.order_id where distance<>'null')select customer_id,round(avg(distance1),2) from a group by customer_id

5.--What was the difference between the longest and shortest delivery times for all orders?
with a as(select REGEXP_REPLACE(duration,'[[:alpha:]]','','g')::int as dur,* from pizza_runner.runner_orders where duration<>'null')
select max(dur)-min(dur) diff from a

6.--What was the average speed for each runner for each delivery and do you notice any trend for these values?
with a as(select runner_id,order_id,replace(distance,'km','')::numeric(3,1) as distance1,regexp_replace(duration,'[[:alpha:]]','','g')::numeric(2) as duration from
pizza_runner.runner_orders where distance<>'null' and duration<>'null')
select runner_id,order_id,round(avg(distance1/duration),2) as speed from a group by runner_id,order_id

7.--What is the successful delivery percentage for each runner?
select runner_id,sum(case when pickup_time<>'null' then 1 else 0 end)::float/count(order_id)*100 percentage  from pizza_runner.runner_orders group by runner_id
