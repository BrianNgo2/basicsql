-- WHERE clause 

/* Ex1. (slide) From table DimEmployee, select all records that satisfy one of the following conditions: 

• DepartmentName is equal to 'Tool Design 

• Status does NOT include the value NULL 

• StartDate in the period from '2009-01-01' to '2009-12-31' 

And must have VacationHours > 10 */ 

-- Your code here 

use AdventureWorksDW2019 

go 

Select *  

From dbo.Dimemployee  

Where 

[VacationHours] > 10 and 

 [DepartmentName]='Tool Design'  

or [Status] IS NOT NULL  

or [StartDate] between '2009/01/01' and '2009/12/31'  
--- Bài làm chưa đúng , thiếu điều kiện VacationHour > 10 

 

/*Ex2. From DimProduct display ProductKey, ProductAlternateKey and EnglishProductName of products  

which have ProductAlternateKey begins with 'BK-' followed by any character other than 'T' and ends with a '-' followed by any two numerals.  

And satisfy Color are black, red, or white  */

-- Your code here 

SELECT 

ProductKey 

, ProductAlternateKey 

,EnglishProductName  

FROM dbo.DimProduct 

Where ProductAlternateKey like 'BK-[^T]%' and  

ProductAlternateKey like '%-[0-9][0-9]' 

and [Color] in ('Black', 'Red', 'White') 

--- Bài làm chưa đúng phần thể hiện kí tự khác T 

 

 

/*Ex3: From FactInternetSales, get a the records which ordered from '2011-01-01' and shipped in 2011 */  

-- Your code here 

SELECT * 

FROM FactInternetSales 

WHERE [OrderDate] >= '2011-01-01' 

and YEAR([ShipDate]) = '2011' 

-- Data types functions 
--- Bài làm đúng 

 

 

 /* Ex4. From DimEmployee table, get EmployeeKey, then: 

- Generate a new field named 'Full Name' which combined FirstName, MiddleName, LastName columns (by 2 ways: using '+' and functions)  

(Noted that MiddleName might contain NULL) 

- Calculate age of each Employee when they are hired using HireDate, BirthDate columns  

- Calculate age of each Employee today using BirthDate column 

- Get user name of each employee. Username is last part of login ID: adventure-works\jun0 -> Username = jun0 

*/ 

-- Your code here 

SELECT 

EmployeeKey 

---Cach1 function: 

,CONCAT([FirstName],' ',[MiddleName],' ',[LastName]) as [FullName1] 

---Cach 2 + : 

,[FirstName]+' '+ISNULL([MiddleName],'')+' '+[LastName] as [FullName2] 

,DATEDIFF(YEAR,[BirthDate],[HireDate]) AS HiredAge 

,DATEDIFF(YEAR,[BirthDate],GETDATE()) AS Age  

,[LoginID] 

--Cach1 Substring() 

, Substring([LoginID],17,256) as UserNameCach1 

--Cach 2 Stuff() 

,Stuff([LoginID],1,16,'') as UserNameCach2 

--Cach3 Replace() 

,Replace([LoginID],'adventure-works\','') as UserNameCach3 

FROM DimEmployee 

 

 

--- Bài làm chưa đúng, yêu cầu tạo column FullName bằng 2 cách\ 

 

 

/* Ex5: From DimEmployee get EmployeeKey, Full Name (combine FirstName, MiddleName and LastName) of all employees that have 8th character (from left) in FirstName equal to "a"  

-- Your code here */

SELECT  

EmployeeKey 

,CONCAT([FirstName],' ',[MiddleName],' ',[LastName]) as [FullName] 

FROM DimEmployee 

Where  

---Cach1 stuff() remove 7 kí tự đầu => kí tự 1 (8 trong chuỗi cũ) là a  

---Stuff([FirstName],1,7,'') like 'a%'  

---Cach2 substring() Lấy first name từ kí tự 8 => kí tự đầu chuỗi mới là a 

---SUBSTRING([FirstName],8,256) like 'a%' 

---Cach 3 hàm left() Lấy hàm 8 kí tự trái của first name => có hai trường hợp Th1 tên đủ 8 kí tự thì kết quả đúng Th2 tên không đủ 8 kí tự vẫn trả ra nhiêu tên có kí tự cuối là a => sai cần thêm điều kiện độ dài. 

Len([FirstName]) >= 8 

and left(FirstName,8) like '%a' 

---Bài làm đúng, nhưng nên sử dụng CONCAT_WS, nếu vẫn dùng CONCAT thì cần dùng ISNULL ở MiddleName nhé 