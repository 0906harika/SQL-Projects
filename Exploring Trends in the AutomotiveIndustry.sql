select * from ExploringTrendsintheAutomotiveIndustry;

--- 1. Calculate the average selling price for cars with a manual transmission and owned by the first owner, for each fuel type. ---
select fuel,avg(selling_price) as selling_price from ExploringTrendsintheAutomotiveIndustry 
where transmission='Manual' and owner='First Owner' group by fuel;

--- 2. Find the top 3 car models with the highest average mileage, considering only cars with more than 5 seats.---
select Name,avg(mileage) as a_mileage from ExploringTrendsintheAutomotiveIndustry where seats > 5
group by Name order by a_mileage desc limit 3;

--- 3. Identify the car models where the difference between the maximum and minimum selling prices is greater than $10,000. ---
select Name from ExploringTrendsintheAutomotiveIndustry group by Name 
Having Max(selling_price)- Min(selling_price) > 10000;

--- 4. Retrieve the names of cars with a selling price above the overall average selling price and a mileage below the overall average mileage. ---
select Name from ExploringTrendsintheAutomotiveIndustry where 
selling_price > (select avg(selling_price) from ExploringTrendsintheAutomotiveIndustry)
and mileage < (select avg(mileage) from ExploringTrendsintheAutomotiveIndustry);

--- 5. Calculate the cumulative sum of the selling prices over the years for each car model. ---
select Name, year, selling_price, sum(selling_price) over (partition by Name  order by year) as cumulative_sum
from ExploringTrendsintheAutomotiveIndustry;

--- 6. Identify the car models that have a selling price within 10% of the average selling price. ---
select Name, selling_price from ExploringTrendsintheAutomotiveIndustry
where selling_price between (select avg(selling_price) * 0.9 from ExploringTrendsintheAutomotiveIndustry)
and (select avg(selling_price) * 1.1 from ExploringTrendsintheAutomotiveIndustry);

--- 7. Calculate the exponential moving average (EMA) of the selling prices for each car model, considering a smoothing factor of 0.2. ---
select Name, year, selling_price,
avg(selling_price) over (partition by Name order by year rows between unbounded preceding and current row)
as ema_selling_price from ExploringTrendsintheAutomotiveIndustry;

--- 8. Identify the car models that have had a decrease in selling price from the previous year. ---
select Name,year,selling_price from( 
select Name, year, selling_price, LAG(selling_price) over (partition by Name order by year) as previous_year
from ExploringTrendsintheAutomotiveIndustry) as price_changes where selling_price < previous_year;

--- 9. Retrieve the names of cars with the highest total mileage for each transmission type. ---
with totalmileage as(
select Name, transmission, sum(km_driven) as total_mileage from ExploringTrendsintheAutomotiveIndustry
group by Name,transmission)
  
select Name,transmission, total_mileage from totalmileage where (transmission,total_mileage) 
in (select transmission, max(total_mileage) from totalmileage group by transmission);

--- 10. Find the average selling price per year for the top 3 car models with the highest overall selling prices. ---
with rankedsellingprice as (
select Name,selling_price,Rank() over (partition by Name order by selling_price desc) as price_rank
from ExploringTrendsintheAutomotiveIndustry)
      
 select Name, year, avg(selling_price) as avg_selling_price_per_year 
from ExploringTrendsintheAutomotiveIndustry where Name IN
(select Name from rankedsellingprice where price_Rank < =3) group by Name,year;
 


  
