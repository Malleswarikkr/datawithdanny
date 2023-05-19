-1.-How many runners signed up for each 1 week period?
Ans:select count(runner_id), date_trunc('week',registration_date)+ INTERVAL '4 days' as week from pizza_runner.runners group by 
date_trunc('week',registration_date)+ INTERVAL '4 days'

