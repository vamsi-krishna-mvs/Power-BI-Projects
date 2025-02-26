use bank_crm;

-- Data CheckUP

select * -- max(CreditScore) , min(CreditScore)  
from bank_churn
order by 2
-- ----
select * -- count(*)
from activecustomer

delete 
from activecustomer
where ACtiveID = ""
 
SET SQL_SAFE_UPDATES = 0;
-- ----

select * -- count(*)
from creditcard

select count(*)
from customerinfo

select * -- count(*)
from exitcustomer

select * -- count(*)
from gender

select * -- count(*)
from geography

drop table customerinfo;

-- ---- OBJECTIVE QUESSTIONS

2. Identify the top 5 customers with the highest Estimated Salary in the last quarter of the year. (SQL)

alter table customerinfo
modify column Bank_DOJ date;

-- Changing column name to Bank_DOJ
alter table customerinfo
rename column `Bank DOJ` to Bank_DOJ ;

select  surname,quarter(Bank_DOJ) as Q,Bank_DOJ
from customerinfo;

select CustomerId, Surname, EstimatedSalary, Bank_DOJ
from customerinfo 
where quarter(Bank_DOJ) = 4  
order by EstimatedSalary desc
limit 5;


3.	Calculate the average number of products used by customers who have a credit card. (SQL)

select avg(NumofProducts) as Avg_numof_products
from bank_churn
where HasCrCard = 1;


5.	Compare the average credit score of customers who have exited and those who remain. (SQL)

select ec.ExitCategory, avg(bc.CreditScore) as Avg_Creditscore
from bank_churn bc
join exitcustomer ec on bc.exited=ec.exitId 
group by ec.ExitCategory;


6.	Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)

select GenderCategory,round(avg(EstimatedSalary),2) as Avg_estimated_sal
from customerinfo ci
join gender g on ci.genderID=g.genderID
group by GenderCategory

select GenderCategory,round(avg(EstimatedSalary),2) as Avg_estimated_sal, count(bc.CustomerId) as Active_Customers
from customerinfo ci
join gender g on ci.genderID=g.genderID
join bank_churn bc on bc.customerID=ci.customerID
join activecustomer ac on  bc.IsActiveMember=ac.ActiveID
where ActiveCategory='Active Member'
group by GenderCategory


7.	Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)

with creditscoresegment as (
    select CustomerId, Exited,
    case when creditscore between 781 and 850 then 'Excellent'
        when creditscore between 701 and 780 then 'Very Good'
        when creditscore between 611 and 700 then 'Good'
        when creditscore between 510 and 610 then 'Fair' else 'Poor'
    end as CreditScoreSegment
    from bank_churn)

select CreditScoreSegment,
    avg(case when Exited = 1 then 1 else 0 end) as Exit_Rate
from creditscoresegment
group by creditscoresegment
order by exit_rate desc
limit 1;


8.	Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)


select g.GeographyLocation, count(b.CustomerId) as Active_Customers
from geography g
join customerinfo c on g.geographyid = c.geographyid
join bank_churn b on c.customerid = b.customerid
where b.tenure > 5 and b.IsActiveMember=1
group by g.geographylocation
order by active_customers desc
limit 1;


11.	 Examine the trend of customers joining over time and identify any seasonal patterns (yearly or monthly). 
		Prepare the data through SQL and then visualize it.

select  year(Bank_DOJ), count(*) as customers_joined
from customerinfo 
group by year(Bank_DOJ)

select  year(Bank_DOJ) as Year ,month(Bank_DOJ) as Month, count(*) as Customers_Joined
from customerinfo 
group by year(Bank_DOJ),month(Bank_DOJ)
order by year,month;


15.	 Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. 
		Also, rank the gender according to the average value. (SQL)

select geo.GeographyLocation,  GenderCategory,
round(avg(c.estimatedsalary),2) as Avg_salary,
rank() over (partition by GeographyLocation 
order by avg(c.EstimatedSalary) desc) as 'Rank'
from customerinfo c
join geography geo on c.geographyid = geo.geographyid
join gender gn on gn.genderid=c.genderid
group by geo.geographylocation, GenderCategory
order by geo.geographylocation


16.	Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).

select case when age between 18 and 30 then 'Adults'
	when age between 31 and 50 then 'Middle-aged'
    else 'Old-aged' end as Age_brackets,
	avg(b.tenure) as Avg_tenure
from customerinfo c
join bank_churn b on c.customerid = b.customerid
where b.exited = 1
group by Age_brackets
order by Age_brackets


19.	Rank each bucket of credit score as per the number of customers who have churned the bank.

with creditscoresegment as (
    select customerid, exited,
    case when creditscore between 781 and 850 then 'excellent'
        when creditscore between 701 and 780 then 'very good'
        when creditscore between 611 and 700 then 'good'
        when creditscore between 510 and 610 then 'fair' else 'poor'
    end as creditscoresegment
    from bank_churn)

select creditscoresegment,
    count(case when exited = 1 then 1 else 0 end) as churned_cnt
from creditscoresegment
group by creditscoresegment
order by churned_cnt desc


20.	According to the age buckets find the number of customers who have a credit card. 
		Also retrieve those buckets that have lesser than average number of credit cards per bucket.

with creditinfo as (
    select case when age between 18 and 30 then 'Adult'
		when age between 31 and 50 then 'Middle-aged'
		else 'Old-aged' end as agebrackets,
		count(c.customerid) as CrCard_holders
    from customerinfo c
    join bank_churn b on c.customerid = b.customerid
    where b.hascrcard = 1  
    group by agebrackets
)
select *
from creditinfo
where CrCard_holders < (
    select avg(CrCard_holders) 
    from creditinfo	);


23.	Without using “Join”, can we get the “ExitCategory” from ExitCustomers table to Bank_Churn table? If yes do this using SQL.

select customerid, creditscore, tenure, balance, numofproducts, hascrcard, isactivemember, exited,
    (select ExitCategory from exitcustomer ec where bc.exited = ec.exitID) as ExitCategory
from bank_churn bc;


25.	Write the query to get the customer IDs, their last name, and whether they are active 
or not for the customers whose surname ends with “on”.

select c.CustomerId, c.Surname as Last_name,  
    case when b.isactivemember = 1 then 'active' 
    else 'inactive' end as activitystatus
from customerinfo c
join bank_churn b on c.customerid = b.customerid
where c.surname like '%on'
order by c.surname;


26.	Can you observe any data disrupency in the Customer’s data? As a hint it’s present in the IsActiveMember and Exited columns. 
One more point to consider is that the data in the Exited Column is absolutely correct and accurate.

select * from bank_churn b join customerinfo c on b.customerid = c.customerid
where b.exited =1 and b.isactivemember =1;


-- Subjective Questions

9.	Utilize SQL queries to segment customers based on demographics and account details.

select GeographyLocation, 
    case when estimatedsalary < 50000 then 'Low'
        when estimatedsalary < 100000 then 'Medium'
        else 'High'end as Income_Segment,
		GenderCategory ,
    count(c.customerid) as NumberofCustomers
from customerinfo c
join geography g on c.geographyid = g.geographyid
join gender gn on c.genderid=gn.genderid
group by  geographylocation, Income_Segment, GenderCategory
order by geographylocation;


14.	In the “Bank_Churn” table how can you modify the name of the “HasCrCard” column to “Has_creditcard”?


alter table Bank_Churn
rename column HasCrCard to Has_creditcard ;

select *
from bank_churn

alter table Bank_Churn
rename column Has_creditcard to HasCrCard ;
