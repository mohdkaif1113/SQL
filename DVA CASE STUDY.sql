

select*from [Customer Data]
select*from [Order Data]


--Q1. Total Revenue (order value)
select sum(ORDER_TOTAL) as total_revenue
from [Order Data]

--Q2. Total Revenue (order value) by top 25 Customers
select top 25 CUSTOMER_KEY, sum(ORDER_TOTAL) as total_revenue
from [Order Data]
group by CUSTOMER_KEY
order by total_revenue desc

--Q3. Total number of orders
select count(ORDER_NUMBER) as total_orders
from [Order Data]

--Q4. Total orders by top 10 customers
select top 10 CUSTOMER_KEY,count(ORDER_NUMBER) as total_orders
from [Order Data]
group by CUSTOMER_KEY
order by total_orders desc

--Q5. Number of customers ordered once
select cast(count(CUSTOMER_KEY) as int) as orderredonce
from (
	select CUSTOMER_KEY, count(ORDER_NUMBER) as order_count from [Order Data]
	group by CUSTOMER_KEY
	having count(ORDER_NUMBER)=1
	) as t
--Q6. Number of customers ordered multiple times
select cast(count(CUSTOMER_KEY) as int) as orderredonce
from (
	select CUSTOMER_KEY, count(ORDER_NUMBER) as order_count from [Order Data]
	group by CUSTOMER_KEY
	having count(ORDER_NUMBER)>1
	) as t
--Q7. Number of customers reffered to other customers
select count(CUSTOMER_ID) as referred_other_customers
from [Customer Data]
where Referred_Other_customers = 'y'

--Q8. Which Month have maximum Revenue?
select  top 1 month(ORDER_DATE) as months,sum(ORDER_TOTAL) as maximum_revenue
from [Order Data]
group by month(ORDER_DATE)
order by maximum_revenue desc


--Q9. Number of customers are inactive (that haven't ordered in the last 60 days)
select count(CUSTOMER_ID)
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
having  max(ORDER_DATE)  < dateadd(day,-60,getdate())

--Q10. Growth Rate  (%) in Orders (from Nov’15 to July’16)
--Q11. Growth Rate (%) in Revenue (from Nov'15 to July'16)
--Q12. What is the percentage of Male customers exists?
select  
	sum(case when gender ='m' then 1 else 0 end)*100 / count(*) as mele_percent
from [Customer Data]

--Q13. Which location have maximum customers?
select top 1 Location
from [Customer Data]
group by Location
order by count(CUSTOMER_ID) desc


--Q14. How many orders are returned? (Returns can be found if the order total value is negative value)
select count(*) as return_order
from [Order Data]
where ORDER_TOTAL like '-%'


--Q15. Which Acquisition channel is more efficient in terms of customer acquisition?
select top 1 Acquired_Channel
from [Customer Data]
group by Acquired_Channel
order by count(Acquired_Channel) desc


--Q16. Which location having more orders with discount amount?
select top 1 Location
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
where DISCOUNT >0
group by Location
order by count(ORDER_NUMBER) desc

--Q17. Which location having maximum orders delivered in delay?
select top 1 Location,count(ORDER_NUMBER) as order_count
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
--where DELIVERY_STATUS = 'late'
group by Location
order by count(ORDER_NUMBER) desc

--Q18. What is the percentage of customers who are males acquired by APP channel?
select
	sum(case when gender = 'm' then 1 else 0 end)*100/count(*) as percnt_male_cust
	from [Customer Data]
	where Acquired_Channel = 'app'


--Q19. What is the percentage of orders got canceled?
select
	sum(case when order_status = 'cancelled' then 1 else 0 end)*100.0/count(*) as percent_order_cancel
	from [Order Data]

--Q20. What is the percentage of orders done by happy customers (Note: Happy customers mean customer who referred other customers)?
select 
		(sum (case when Referred_Other_customers = 'Y' then 1 else 0 end)*100.0)/
		COUNT(*) as Happy_customer from [Customer Data]

--Q21. Which Location having maximum customers through reference?

select top 1 Location,count(*) as reffered_customer from [Customer Data]
where Referred_Other_customers = 'Y'
group by Location
order by reffered_customer desc

--Q22. What is order_total value of male customers who are belongs to Chennai and Happy customers (Happy customer definition is same in question 21)?
select sum(ORDER_TOTAL) as order_total_value
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
where Gender = 'm' and Location = 'chennai' and Referred_Other_customers ='y'


--Q23. Which month having maximum order value from male customers belongs to Chennai? 
select top 1 month(ORDER_DATE) as	Months,SUM(ORDER_TOTAL) as max_order_valus	
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
where gender = 'm' and location = 'chennai'
group by month(ORDER_DATE)
order by max_order_valus desc


--Q24. Prepare at least 5 additional analysis on your own?
--(i)most frequent channel used
select Acquired_Channel,count(*) total_count
from [Customer Data]
group by Acquired_Channel
order by total_count desc

--(ii)average order value  in each year
select  year(ORDER_DATE) as years,avg(ORDER_TOTAL) as avg_order_value
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
group by year(ORDER_DATE) 
order by year(ORDER_DATE)


--(iii) average order value from different locations
select  Location,avg(ORDER_TOTAL)as avg_order_value
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
group by Location
order by avg_order_value desc

--(iv)from which location customer have referred most
select Location,count(Referred_Other_customers) as referred
from [Customer Data]
where Referred_Other_customers = 'y'
group by Location
order by referred desc

--(v) top 100 customers in terms of order value 
select top 100 CUSTOMER_ID,sum(ORDER_TOTAL) as order_value
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
group by CUSTOMER_ID
order by order_value desc


--Q25. What are number of discounted orders ordered by female customers who were acquired by website from Bangalore delivered on time?
select count(DISCOUNT) as discounted_orders
from [Order Data] as c
LEFT JOIN [Customer Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
where  O.Gender = 'F' 
and O.Acquired_Channel = 'Website'
and O.Location = 'Banglore'
	and C.ORDER_STATUS = 'Delivered'
	and C.DELIVERY_STATUS = 'On-Time'
	AND DISCOUNT>0


	SELECT * FROM [Customer Data]
	SELECT * FROM [Order Data]