SELECT *
FROM app_store_apps;

SELECT *
FROM play_store_apps;

with table_1 as (SELECT name 
				 from app_store_apps
				 WHERE rating > (select avg(rating)from app_store_apps))
SELECT distinct genres from play_store_apps
INNER join table_1 using(name)
WHERE rating > (select avg(rating)from play_store_apps);

-- total profit for each app

WITH both_stores_cte AS (SELECT name,primary_genre,rating,price::decimal, 'app_store_apps' AS location,
						CASE WHEN price :: decimal <= 2.5 THEN 2500
							 WHEN price :: decimal >2.5 THEN (price::decimal*10000)
							 END as purchase_price,'5000' AS revenue_per_month,
						     1+ (rating*2)*12 AS app_life_span_months
						     FROM app_store_apps 
						     UNION
						SELECT name,category ,rating,price::money::decimal, 'play_store_apps' AS location,
						CASE WHEN price :: money:: decimal <= 2.5 THEN 2500
							 WHEN price :: money:: decimal >2.5 THEN (price::money::decimal*10000)
							 END as purchase_price,'5000' AS revenue_per_month,
						     1+ (rating*2)*12 AS app_life_span_months
						     FROM play_store_apps)
SELECT name,price,purchase_price,revenue_per_month,rating,app_life_span_months,
			(revenue_per_month::decimal*app_life_span_months:: decimal)AS total_revenue,
			(revenue_per_month::decimal*app_life_span_months:: decimal) - purchase_price AS total_profit
FROM both_stores_cte
WHERE price=0.00 and rating = 5.0
ORDER by total_profit DESC;



