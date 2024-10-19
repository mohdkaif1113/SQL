select State,Date
from DIM_LOCATION as l
inner join FACT_TRANSACTIONS as t
on l.IDLocation=t.IDLocation
where year(Date) between 2005 and GETDATE()
order by State



select top 1 Country,State,sum(Quantity) as total_qnty
from DIM_LOCATION as l
inner join FACT_TRANSACTIONS as t
on l.IDLocation=t.IDLocation
inner join DIM_MODEL as m
on t.IDModel=m.IDModel
inner join DIM_MANUFACTURER as dm
on m.IDManufacturer=dm.IDManufacturer
where Country = 'us' and Manufacturer_Name = 'samsung'
group by Country,State
order by sum(Quantity) desc



select Model_Name,ZipCode,State,count(IDCustomer) as transactions
from DIM_LOCATION as l
inner join FACT_TRANSACTIONS as t
on l.IDLocation=t.IDLocation
inner join DIM_MODEL as m
on t.IDModel=m.IDModel
group by Model_Name,ZipCode,State
order by 4 desc



select top 1 Model_Name,Unit_price
from DIM_MODEL
group by Model_Name,Unit_price
order by Unit_price


select Model_Name,avg(TotalPrice) as average_price,sum(Quantity) as qty
from FACT_TRANSACTIONS as t
inner join DIM_MODEL as m
on t.IDModel=m.IDModel
inner join DIM_MANUFACTURER as dm
on m.IDManufacturer=dm.IDManufacturer
group by Model_Name
order by average_price desc
					 
				
select Customer_Name,avg(TotalPrice) as avg_spend,Date
from DIM_CUSTOMER as c
inner join FACT_TRANSACTIONS as t
on c.IDCustomer=t.IDCustomer
where year(Date)=2009
group by Customer_Name,Date
having avg(TotalPrice)>500 



select distinct top 5 Model_Name,sum(Quantity) as qty,Date
from DIM_MODEL as m
inner join FACT_TRANSACTIONS as t
on m.IDModel=t.IDModel
where year(date) in (2008,2009,2010)
group by Model_Name,Date
order by qty desc


with cte1 as
(
select  Manufacturer_Name, sum(TotalPrice) as t,DENSE_RANK() over ( partition by year(date) order by sum(TotalPrice) desc) as ranks 
from DIM_MANUFACTURER as m
inner join DIM_MODEL as md
on m.IDManufacturer=md.IDManufacturer
inner join FACT_TRANSACTIONS as t
on md.IDModel=t.IDModel
group by Manufacturer_Name,year(Date)
)