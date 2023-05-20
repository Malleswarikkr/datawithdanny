1.What are the standard ingredients for each pizza?
WITH split_table AS (
  SELECT
    pizza_id,
    unnest(string_to_array(toppings, ', '))::int AS topping
  FROM
    pizza_runner.pizza_recipes
)
SELECT topping_name,count( distinct pizza_id)
FROM split_table as st inner join pizza_runner.pizza_toppings as pt on st.topping=pt.topping_id group by topping_name having count( distinct pizza_id)=2
 
2.-- what was the most commonly added extra?

WITH split_table AS (
  SELECT
    extras,
    unnest(string_to_array(extras, ', '))::int AS topping
  FROM
    pizza_runner.customer_orders where extras<>'null'
)
SELECT topping,count(topping) ,topping_name from split_table inner join pizza_runner.pizza_toppings as pt on split_table.topping=pt.topping_id 
where topping<>1 group by topping,topping_name 


3.What was the most common exclusion?
WITH split_table AS (
  SELECT
    exclusions,
    unnest(string_to_array(exclusions, ', '))::int AS topping
  FROM
    pizza_runner.customer_orders where exclusions<>'null'
)
SELECT topping,count(topping) ,topping_name from split_table inner join pizza_runner.pizza_toppings as pt on split_table.topping=pt.topping_id    group by
topping,topping_name 
