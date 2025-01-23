use electoralbonddata;

SELECT * FROM electoralbonddata.bankdata;
SELECT * FROM electoralbonddata.bonddata;
SELECT * FROM electoralbonddata.donordata;
SELECT * FROM electoralbonddata.receiverdata;



---------- 1. Find out how much donors spent on bonds
select purchaser,sum(denomination) as value 
from donordata
left join bonddata on donordata.Unique_key= bonddata.Unique_key
group by 1  
order by 2 desc;

---------------- 2.  Find out total fund politicians got

select partyname,sum(denomination) as value 
from receiverdata 
left join bonddata on receiverdata.Unique_key=bonddata.Unique_key
group by 1 
order by 2 desc;

-------- 3.  Find out the total amount of unaccounted money received by parties
SELECT SUM(Denomination) as 'Unaccounted Amount'
FROM donordata as a  
RIGHT JOIN receiverdata as r ON r.Unique_key = a.Unique_key
JOIN bonddata as c  ON r.Unique_key = c.Unique_key
WHERE purchaser IS NULL; 



-------- 4. . Find year wise how much money is spend on bonds

SELECT YEAR(a.PurchaseDate) AS `year`,SUM(Denomination) AS 'year wise bond spending'
FROM donordata as a
JOIN bonddata as b ON b.unique_key = a.unique_key
GROUP BY 1
ORDER BY 2 DESC;

--------- 5. In which month most amount is spent on bonds

SELECT MONTH(a.PurchaseDate) AS `Month`, SUM(b.Denomination) AS 'city bond spending'   
FROM donordata as a
JOIN bonddata as b ON b.unique_key = a.unique_key
GROUP BY 1 order by 2 desc limit 1;

--------- 6. Find out which company bought the highest number of bonds.
 
SELECT purchaser, COUNT(denomination) 
FROM donordata as d 
JOIN bonddata as b ON d.Unique_key = b.Unique_key
GROUP BY 1
Order by 2 desc
Limit 1;


------- 7.  Find out which company spent the most on electoral bonds

select Purchaser,sum(denomination) as most_spent
from donordata as a
join bonddata as b on a.Unique_key=b.Unique_key
group by 1
Order by 2 desc
Limit 1;

--------- 8. list companies which paid the least to political parties
select Purchaser,sum(Denomination) as 'Amount paid'
from donordata as a
join bonddata as b on a.Unique_key=b.Unique_key
group by 1
order by 2 ASC
limit 1;

---------- 9.  Which political party received the highest cash?

select r.PartyName,sum(b.denomination) as Cash_Recevied
from receiverdata as r
join bonddata as b
on r.Unique_key=b.Unique_key
group by 1 
order by 2 desc 
limit 1;

-------- 10. Which political party received the highest number of electoral bonds?

select r.PartyName,count(b.denomination) as no_of_electoralbonds
from receiverdata as r
join bonddata as b
on r.Unique_key=b.Unique_key
group by 1 
order by 2 desc 
limit 1;

---------- 11.  Which political party received the least cash? 

select PartyName,sum(denomination) as Amount_received
from receiverdata as r
join bonddata as b 
on r.Unique_key=b.Unique_key
group by 1 
order by 2 asc 
limit 1;

------------ 12.  Which political party received the least number of electoral bonds?
select PartyName,count(denomination) as NUMBER_OF_BONDS_RECEIVED
from receiverdata as r
join bonddata as b 
on r.Unique_key=b.Unique_key
group by 1 
order by 2 asc 
limit 1;

---------------- 13.  Find the 2nd highest donor in terms of amount he paid?
select purchaser,sum(denomination) as Amount_paid
from donordata as a
join bonddata as b 
on a.Unique_key=b.Unique_key
group by 1 
order by 2 desc 
limit 1 
offset 1;

--------- 14. Find the party which received the second highest donations?

select PartyName,sum(denomination) as Donations
from receiverdata as r 
join bonddata as b 
on r.Unique_key=b.Unique_key
group  by 1 
order by 2 desc 
limit 1 
offset 1 ;

------ 15.  Find the party which received the second highest number of bonds?

select PartyName,count(denomination) as Second_Highest_Bonds
from receiverdata as a
join bonddata as b 
on a.Unique_key=b.Unique_key
group  by 1 
order by 2 desc 
limit 1 
offset 1 ;

------- 16. In which city were the most number of bonds purchased?

select city,count(denomination) as no_of_bonds
from donordata as a
join bonddata as b on  a.Unique_key=b.Unique_key
join bankdata as c on c.branchcodeno=a.paybranchcode
group by 1 
order by 2 desc 
limit 1 ;

---------- 17.  In which city was the highest amount spent on electoral bonds?

select city,sum(denomination) as Amount_spent
from donordata as a
join bonddata as b on  a.Unique_key=b.Unique_key
join bankdata as bc on bc.branchcodeno=a.paybranchcode
group by 1 
order by 2 desc 
limit 1;

------ 18.  In which city were the least number of bonds purchased?

select city,count(denomination) as no_of_bonds
from donordata as a
join bonddata as b on a.Unique_key=b.Unique_key
join bankdata as bc on bc.branchcodeno=a.paybranchcode
group by 1 
order by 2 asc 
limit 1;

------ 19. In which city were the most number of bonds enchased?
select city,count(denomination) as Enchased
from donordata as d
join bonddata as b on d.Unique_key=b.Unique_key
join bankdata as bd on bd.branchcodeno=d.paybranchcode
group by 1 
order by 2 desc 
limit 1;

------ 20.  In which city were the least number of bonds enchased?

select city,count(denomination) as Enchased
from donordata as d
join bonddata as b on d.Unique_key=b.Unique_key
join bankdata as bd on bd.branchcodeno=d.paybranchcode
group by 1 
order by 2 asc 
limit 1;

----- 21.  List the branches where no electoral bonds were bought; if none, mention it as null.

select * from (
select branchcodeno,count(unique_key) bonds from bankdata as a
left join donordata as b on a.branchcodeno=b.paybranchcode group by 1 order by 2 asc) a where bonds=0;

------- 22. Break down how much money is spent on electoral bonds for each year.
SELECT YEAR(d.PurchaseDate) AS `year` ,SUM(c.Denomination) AS 'year wise bond spending'
FROM donordata d
JOIN bankdata b ON d.paybranchcode = b.branchcodeNo
JOIN bonddata c ON c.unique_key = d.unique_key
GROUP BY `year`
ORDER BY `year wise bond spending` DESC;
 
 -------- 24. Find out how many donors bought the bonds but did not donate to any political party?
select count(*) from donordata as a
left join receiverdata as b on b.Unique_key= a.Unique_key
where b.PartyName is Null;

---------- 25. Find out the money that could have gone to the PM Office, assuming the above question assumption (Domain Knowledge)

SELECT SUM(Denomination) FROM donordata as a
LEFT JOIN receiverdata as b ON b.Unique_key = a.Unique_key
INNER JOIN bonddata as c ON c.Unique_key = a.Unique_key
WHERE PartyName is NULL;

------ 26. Find out how many bonds dont have donors associated with them?


SELECT COUNT(*)
FROM donordata d
RIGHT JOIN receiverdata r ON r.Unique_key = d.Unique_key
WHERE purchaser is NULL;
 
------- 27.  PayTeller is the employee ID who either created the bond or redeemed it. So find the employee ID who issued the highest number of bonds.
SELECT PayTeller, COUNT(*) AS highest_no_of_bonds
FROM receiverdata
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

------- 28.Find the employee ID who issued the least number of bonds.

SELECT PayTeller, COUNT(*) AS Least_no_of_bonds
FROM receiverdata
GROUP BY 1
ORDER BY 2 ASC
LIMIT 1;

--------- 29.  Find the employee ID who assisted in redeeming or enchasing bonds the most.
WITH ranked_redeemers AS (
    SELECT payteller, 
           COUNT(unique_key) AS redemption_count,
           RANK() OVER (ORDER BY COUNT(unique_key) DESC) AS redeemer_rank
    FROM receiverdata
    GROUP BY 1
)
SELECT payteller, redemption_count
FROM ranked_redeemers
WHERE redeemer_rank = 1;

-------- 30. Find the employee ID who assisted in redeeming or enchasing bonds the least
WITH ranked_enchasing AS (
    SELECT payteller, 
           COUNT(unique_key) AS redemption_count,
           RANK() OVER (ORDER BY COUNT(unique_key) ASC) AS enchasing_rank
    FROM receiverdata
    GROUP BY 1
)
SELECT payteller, redemption_count
FROM ranked_enchasing
WHERE enchasing_rank = 1;


----------------------------------------------------------------------------------------------------------------------------------
------ Some more Questions you can try answering Once you are done with above questions.

------- 1.Tell me total how many bonds are created?
select count(Unique_key) as 'total bonds'
from bonddata;

-------- 2.  Find the count of Unique Denominations provided by SBI?
select count(DISTINCT Denomination) as 'Unique Denominations'
from bonddata;

-------- 3.  List all the unique denominations that are available?
select distinct(Denomination) as 'Unique Denominations' 
From bonddata;

-------- 4. Total money received by the bank for selling bonds
select sum(Denomination) as 'Total Amount Recevied By The Bank'
from bonddata;

----------- 5.Find the count of bonds for each denominations that are created.
SELECT Denomination, COUNT(Denomination) as 'count of Denominations'
FROM bonddata
GROUP BY 1
ORDER BY 2;
 
 --------- 6.Find the count and Amount or Valuation of electoral bonds for each denominations.
SELECT Denomination, COUNT(*) AS BondCount, SUM(Denomination) AS 'Total Valuation'
FROM bonddata 
GROUP BY 1;
 
------- 7. Number of unique bank branches where we can buy electoral bond?
select count(branchCodeNo) as 'Unique Bank Branches' 
From bankdata;

------- 8. How many companies bought electoral bonds
SELECT COUNT(DISTINCT purchaser) AS 'Companies'
 FROM donordata;
 
-------- 9. How many companies made political donations
SELECT COUNT(DISTINCT purchaser) AS 'No of Political Donors'
FROM donordata as a
JOIN receiverdata as b on b.Unique_key = a.Unique_key;

--------- 10. How many number of parties received donations
SELECT COUNT(DISTINCT Partyname) AS 'No of Political Parties'
FROM receiverdata;

--------- 11. List all the political parties that received donations
SELECT DISTINCT Partyname AS 'List of political parties'
FROM receiverdata;

--------- 12. What is the average amount that each political party received
SELECT Partyname, avg(Denomination) AS 'Average Amount Received by political party'
FROM receiverdata as a 
JOIN bonddata as b on b.Unique_key = a.Unique_key
GROUP BY 1;

------- 13. What is the average bond value produced by bank
SELECT avg(Denomination) as 'Average bond value'
FROM bonddata;

-------- 14. List the political parties which have enchased bonds in different cities?
SELECT Partyname
 FROM (SELECT Partyname, CITY, COUNT(Unique_key) AS PartyCount
 FROM receiverdata r 
JOIN bankdata b ON r.PayBranchCode = b.branchcodeno 
GROUP BY Partyname, CITY) as d
 GROUP BY Partyname
 HAVING COUNT(CITY) > 1
 ORDER BY Partyname;

--------- 15. List the political parties which have enchased bonds in different cities and list the cities in which the bonds have enchased as well?
 SELECT Partyname, CITY
 FROM (
 SELECT Partyname, CITY, COUNT(Unique_key) AS PartyCount
 FROM receiverdata r 
JOIN bankdata b ON r.PayBranchCode = b.branchcodeno 
GROUP BY Partyname, CITY
 ) AS d
 WHERE Partyname IN (
 SELECT Partyname
 FROM (
 SELECT Partyname, COUNT(DISTINCT CITY) AS CityCount
 FROM receiverdata r 
JOIN bankdata b ON r.PayBranchCode = b.branchcodeno 
GROUP BY Partyname
) AS sub
 WHERE CityCount > 1
 )
 ORDER BY Partyname; 
