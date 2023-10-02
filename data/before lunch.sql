SELECT *
FROM app_store_apps;
 

SELECT *
FROM play_store_apps;



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
	  and name in (SELECT name
				  from play_store_apps
				  INTERSECT
				  SELECT name
				  FROM app_store_apps)
ORDER by total_profit DESC;

--Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.
((WITH both_table As ((select name, price::decimal,rating, review_count::decimal
				   from app_store_apps
				   where price :: money::decimal<=2.50 and ROUND (rating*4)/4=5.0)
				   UNION ALL
				   (select name, price::money::decimal,rating, review_count::decimal
				   from play_store_apps
				   where price :: money::decimal<=2.50 and ROUND (rating*4)/4=5.0))
SELECT *
FROM both_table
WHERE name IN (SELECT name
				  from play_store_apps
				  INTERSECT
				  SELECT name
				  FROM app_store_apps)
order by review_count DESC)
UNION ALL
(with both_table AS ((select name, price::decimal,rating, review_count::decimal
				   from app_store_apps
				   where price :: money::decimal<=2.50 and ROUND (rating*4)/4=5.0)
				   UNION ALL
				   (select name, price::money::decimal,rating, review_count::decimal
				   from play_store_apps
				   where price :: money::decimal<=2.50 and ROUND (rating*4)/4=5.0))
SELECT *
FROM both_table
ORDER BY review_count DESC))
LIMIT 10;
---
--Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for the upcoming
--Halloween themed campaign
with both_table AS ((select name, price::decimal,rating, review_count::decimal
				   from app_store_apps
				   where price :: money::decimal<=2.50 and ROUND (rating*4)/4=5.0)
				   UNION ALL
				   (select name, price::money::decimal,rating, review_count::decimal
				   from play_store_apps
				   where price :: money::decimal<=2.50 and ROUND (rating*4)/4=5.0))
SELECT *
FROM both_table
WHERE name ILIKE '%Halloween%'OR
      name ILIKE '%Spooky%'OR
	  name ILIKE '%Scary%' OR
	  name ILIKE '%Creepy%' OR
	  name ILIKE '%Pumpkin%' OR
	  name ILIKE '%Fall%' OR
	  name ILIKE '%Ghost%' OR
	  name ILIKE '%Skull%' OR
	  name ILIKE '%Zombie%'
ORDER BY review_count DESC
LIMIT 4;
---







