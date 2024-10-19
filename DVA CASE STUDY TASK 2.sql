--Q1. Number of orders by month based on order status (Delivered vs. canceled vs. etc.) - Split of order status by month



select 
		CONVERT(varchar(7),ORDER_DATE,120) as Year_month,
		sum(case when order_status='Delivered' then 1 else 0 end) as Delivered,
		sum(case when order_status='Cancelled' then 1 else 0 end) as Cancelled,
		sum(case when order_status='Created' then 1 else 0 end) as Created,
		sum(case when order_status='Packaged' then 1 else 0 end) as Packaged
		from [Order data]
		group by CONVERT(varchar(7),ORDER_DATE,120)

--Q2. Number of orders by month based on delivery status
select 
		YEAR(ORDER_DATE) as Order_year,
		MONTH(ORDER_DATE) as Order_month,
		
		SUM(case when DELIVERY_STATUS = 'On-Time' then 1 else 0 end) as OnTime,
		SUM(case when DELIVERY_STATUS = 'Late' then 1 else 0 end) as Late
	from [Order data]
	group by YEAR(ORDER_DATE),MONTH(ORDER_DATE)


--Q3. Month-on-month growth in OrderCount and Revenue (from Nov’15 to July’16)
--Q4. Month-wise split of total order value of the top 50 customers (The top 50 customers need to identified based on their total order value)
--Q5. Month-wise split of new and repeat customers. New customers mean, new unique customer additions in any given month
--Q6. Write stored procedure code which take inputs as location & month, and the output is total_order value and number of orders by Gender, 
--Delivered Status for given location & month. Test the code with different options
CREATE PROCEDURE
GetOrderByLocation_and_Month
    @Location NVARCHAR(100),
    @Month DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        SUM(Order_Total) AS TotalOrderValue,
        COUNT(*) AS TotalOrders,
        Gender,
        Delivery_Status
    FROM [Order data] o
    JOIN [Customer Data] as c ON o.CUSTOMER_KEY = c.CUSTOMER_KEY
    WHERE MONTH(Order_Date) = MONTH(@Month)
        AND YEAR(Order_Date) = YEAR(@Month)
        AND c.Location = @Location
    GROUP BY Gender, Delivery_Status;
END


--*Q7. Create Customer 360 File with Below Columns using Orders Data & Customer Data (12 Marks)
	Customer_ID
	CONTACT_NUMBER
	Referred Other customers
	Gender
	Location
	Acquired Channel
	No.of Orders
	Total Order_vallue
	Total orders with discount
	Total Orders received late
	Total Orders returned
	Maximum Order value
	First Transaction Date
	Last Transaction Date
	Tenure_Months  (Tenure is defined as the number of months between first & last transaction) 
--No_of_orders_with_Zero_value
--Q8. Total Revenue, total orders by each location
select Location,sum(ORDER_TOTAL) as total_revenue,count(ORDER_NUMBER) as total_orders
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
group by Location


--Q9. Total revenue, total orders by customer gender
select Gender,sum(ORDER_TOTAL) as total_revenue,count(ORDER_NUMBER) as total_orders
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
GROUP BY Gender


--Q10. Which location of customers cancelling orders maximum?
select TOP 1 Location
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
WHERE ORDER_STATUS = 'CANCELLED'
GROUP BY Location
ORDER BY COUNT(ORDER_STATUS) DESC



--Q11. Total customers, Revenue, Orders by each Acquisition channel
select Acquired_Channel,COUNT(DISTINCT CUSTOMER_ID) AS TOTAL_CUSTOMERS,SUM(ORDER_TOTAL) AS TOTAL_REVENUE,COUNT(ORDER_NUMBER) AS TOTAL_ORDERS
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
GROUP BY Acquired_Channel


--Q12. Which acquisition channel is good interms of revenue generation, maximum orders, repeat purchasers?
select TOP 1 Acquired_Channel,SUM(ORDER_TOTAL) AS TOTAL_REVENUE,COUNT(ORDER_NUMBER) AS MAXIMUM_ORDERS,COUNT(DISTINCT ORDER_NUMBER) AS REPEAT_PURCHASE
from [Customer Data] as c
inner join [Order Data] as o
on c.CUSTOMER_KEY=o.CUSTOMER_KEY
GROUP BY Acquired_Channel
HAVING COUNT(DISTINCT ORDER_NUMBER) > 1 
ORDER BY TOTAL_REVENUE DESC , MAXIMUM_ORDERS DESC



--Q13. Write User Defined Function (stored procedure) which can take input table which create two tables
--with numerical variables and categorical variables separately (6 Marks)
--Q14. Prepare at least 5 additional analysis on your own? (10 Marks)

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