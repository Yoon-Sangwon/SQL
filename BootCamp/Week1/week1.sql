/* 1. Country 별로 ContactName이 ‘A’로 시작하는 Customer의 숫자를 세는 쿼리를 작성하세요. */
SELECT country, count(*) FROM Customers
WHERE `ContactName` LIKE 'A%' GROUP BY country;
/* 쿼리 잘 작성하셨습니다!
추가로 count(1)과 count(*)에는 차이가 없다는 점도 예시답안 보실 때 참고 부탁드립니다. */


/* 2. Customer 별로 Order한 Product의 총 Quantity를 세는 쿼리를 작성하세요. */
SELECT ors.CustomerID, SUM(od.Quantity) AS 'Total Quantity'
FROM Orders AS ors LEFT JOIN OrderDetails AS od
ON ors.OrderID = od.OrderID
GROUP BY ors.CustomerID
ORDER BY ors.CustomerID ASC;
/* 쿼리 깔끔하게 잘 작성하셨습니다~ */


/* 3. 년월별, Employee별로 Product를 몇 개씩 판매했는지와 그 Employee의 FirstName을 표시하는 쿼리를 작성하세요. */
SELECT ors.OrderDate, ors.EmployeeID, em.FirstName, sum(od.Quantity)
FROM Orders AS ors
LEFT JOIN OrderDetails AS od ON ors.OrderID = od.OrderID
LEFT JOIN Employees AS em ON ors.EmployeeID = em.EmployeeID
GROUP BY ors.OrderDate, ors.EmployeeID
/* 이 문제의 경우는 년월일 형태로 되어있는 OrderDate를
어떻게 년월 형태로 바꿀지를 고민해보셨으면 하는 의미로 냈던 문제였습니다.
이런 경우에 MySQL에서는 date_format() 등의 함수를 많이 쓰는데
저 실습환경에서는 그런 함수들이 작동을 안하더라구요.
이럴때는 좀더 원시적(?)이지만 날짜를 문자열로 보고 substr() 함수를 사용하셔도 됩니다.
자세한 건 예시 답안을 참고해주세요! */


/* 전반적으로 쿼리를 다 잘 작성해주셔서 피드백드릴 내용이 별로 없네요 ^^;
1주차 학습을 열심히 잘 해주신 것 같습니다! 고생하셨습니다!! */


/* 예시답안 */
select Country, count(1) cnt
from Customers
where ContactName like 'A%'
group by Country;


select a.CustomerID, sum(b.Quantity)
from Orders a 
    left join OrderDetails b on a.OrderId = b.OrderId
group by a.CustomerID;


select substr(a.OrderDate,1,7) ym, a.EmployeeID, c.FirstName, sum(b.Quantity) sumOfQuantity
from Orders a
	left join OrderDetails b on a.OrderID = b.OrderID
	left join Employees c on a.EmployeeID = c.EmployeeID
group by substr(a.OrderDate,1,7), a.EmployeeID, c.FirstName;
