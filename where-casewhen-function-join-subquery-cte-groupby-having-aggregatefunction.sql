Use AdventureWorksDW2019 

/*Ex 1. From FactInternetSales, DimCustomer 

Caculate TotalSalesAmount by each CustomerKey in each Year. Retain customers who have total value of orders greater than 5000 per year */

SELECT 

    DC.CustomerKey 

    ,Year(Fis.OrderDate) as YearOrder 

    ,SUM(FIS.SalesAmount) as TTSA 

FROM dbo.FactInternetSales as FIS  

JOIN dbo.DimCustomer as DC On FIS.CustomerKey=DC.CustomerKey 

GROUP BY DC.CustomerKey, Year(FIS.OrderDate) 

HAVING SUM(FIS.SalesAmount) > 5000 

ORDER BY CustomerKey , YearOrder  

-- Bài làm đúng 

/* Ex 2: From FactInternetSale, DimProduct, 

Write a query that create new Color_group, if product color is 'Black' or 'Silver' leave 'Basic', else keep Color. 

Then Caculate total SalesAmount by new Color_group */ 

 SELECT  

    B.NewColor, 

    SUM(FIS.SalesAmount) as TSA 

FROM 

    (SELECT ProductKey, 

        CASE  

            WHEN Color in ('Black','Silver','Black/Silver') THEN 'Basic' 

        END as NewColor 

    FROM dbo.DimProduct 

    WHERE Color in ('Black','Silver') ) as B  

    JOIN dbo.FactInternetSales as FIS on B.ProductKey=FIS.ProductKey 

GROUP BY B.NewColor 

UNION 

SELECT 

    A.NewColor, 

    SUM(SalesAmount) 

FROM 

    (Select  

    ProductKey, 

    Color as NewColor 

    From dbo.DimProduct 

    Where Color NOT IN ('Black','Silver')) as A  

JOIN dbo.FactInternetSales as FIS on A.ProductKey=FIS.ProductKey 

GROUP BY A.NewColor 

---Chữa: 
/*
WITH temp as ( 

    SELECT  

    DP.ProductKey, 

    FIS.SalesAmount, 

    CASE  

        WHEN Color in ('Black','Silver') THEN 'Basic' 

        ELSE Color  

        END as NewColor 

    From dbo.DimProduct DP  

    RIGHT JOIN dbo.FactInternetSales FIS ON DP.ProductKey=FIS.ProductKey) 

SELECT  

NewColor, 

SUM(SalesAmount) as Totalsales  

FROM temp 

GROUP BY NewColor 
*/
 

-- Bài làm đúng 

/* Ex 3: From the FactInternetsales and Resellersales tables, retrieve saleordernumber, productkey,  

orderdate, shipdate of orders in October 2011, along with new column named SalesType  (if orders come from FactInternetSales then 'Internet', if orders come from FactResellerSales then 'Reseller') 
*/
SELECT 

    SalesOrderNumber, 

    ProductKey, 

    OrderDate, 

    ShipDate, 

    'Internet' as Salestype  

FROM dbo.FactInternetSales 

WHERE Year(ShipDate) = 2011 and Month(ShipDate) = 10 

UNION 
SELECT 

    SalesOrderNumber, 

    ProductKey, 

    OrderDate, 

    ShipDate, 

    'Reseller'as Salestype  

FROM dbo.FactResellerSales 

WHERE Year(ShipDate) = 2011 and Month(ShipDate) = 10 

ORDER BY ProductKey  

 

-- Bài làm đúng 

/* Ex 4: (advanced) From database  

Caculate Total OrderQuantity ( from OrderQuantity column) of each ProductKey from 2 SalesType (Internet, Resell) where:  

OrderDate in Quarter 3,2013  

And Customer/Resellers live in London 

The result should contain the following columns: ProductKey, EnglishProductName, SalesType, TotalOrderQuantity */

WITH TEST2 AS(   

SELECT  

    DG.City, 

    FIS.ProductKey, 

    FIS.OrderDate, 

    FIS.OrderQuantity 

FROM dbo.FactInternetSales FIS  

JOIN dbo.DimCustomer DC ON DC.CustomerKey=FIS.CustomerKey 

JOIN dbo.DimGeography DG ON DC.GeographyKey=DG.GeographyKey 

WHERE  

        (OrderDate BETWEEN '2013-06-01' and '2013-09-30')  

    and (City = 'london')) 

, TEST1 AS ( 

    SELECT   

    DG.City, 

    FRS.ProductKey, 

    FRS.OrderDate, 

    FRS.OrderQuantity 

    FROM dbo.FactResellerSales FRS 

    JOIN dbo.DimReseller DR ON FRS.ResellerKey=DR.ResellerKey 

    JOIN dbo.DimGeography DG ON DG.GeographyKey=DR.GeographyKey 

    WHERE  

        (OrderDate BETWEEN '2013-06-01' and '2013-09-30')  

    and (City = 'london')) 

SELECT  

    T1.ProductKey, 

    DP.EnglishProductName, 

    SUM(T1.OrderQuantity) as TotalOrderQuantity, 

    'Resell' AS SalesType  

FROM TEST1 T1  

JOIN dbo.DimProduct DP ON T1.ProductKey=DP.ProductKey 

GROUP BY T1.ProductKey, DP.EnglishProductName 

UNION 

SELECT 

    T.ProductKey, 

    DP.EnglishProductName , 

    SUM(T.OrderQuantity) AS TotalOrderQuantity, 

    'Internet' AS SalesType  

FROM TEST2 AS T  

JOIN dbo.DimProduct DP ON T.ProductKey=DP.ProductKey 

GROUP BY T.ProductKey, DP.EnglishProductName 

ORDER BY ProductKey 

 

-- Bài làm đúng 

/* Ex 5 (advanced): From database, retrieve total SalesAmount monthly of internet_sales and reseller_sales.  

The result should contain the following columns: Year, Month, Internet_Sales, Reseller_Sales 

Gợi ý: Tính doanh thu theo từng tháng ở mỗi bảng độc lập FactInternetSales và FactResllerSales bằng sử dụng CTE  */

WITH MFIS AS   

    ( SELECT 

        CONCAT(YEAR(DueDate),'',MONTH(DueDate)) AS SK,  

        YEAR(DueDate) as SALEYEAR, 

        MONTH(DueDate) as SALEMONTH, 

        SUM(SalesAmount) as Monthly_Internet_Sale_Amount 

    FROM dbo.FactInternetSales 

    GROUP BY YEAR(DueDate) , MONTH(DueDate)) , 

    MFRS AS  

    (SELECT  

        CONCAT(YEAR(Duedate),'',MONTH(Duedate)) AS SK,  

        YEAR(DueDate) as SALEYEAR, 

        MONTH(DueDate) as SALEMONTH, 

        SUM(SalesAmount) as Monthly_Resell_Sale_Amount 

    FROM dbo.FactResellerSales 

    GROUP BY YEAR(DueDate) , MONTH(DueDate)) 

SELECT     

    A.SALEYEAR, 

    A.SALEMONTH, 

    A.Monthly_Internet_Sale_Amount, 

    B.Monthly_Resell_Sale_Amount 

FROM MFIS as A  

JOIN MFRS as B ON A.SK=B.SK 

 

---Chữa: 

WITH  

    MFIS AS ( SELECT  

            YEAR(DueDate) as SALEYEAR, 

            MONTH(DueDate) as SALEMONTH, 

            SUM(SalesAmount) as Monthly_Internet_Sale_Amount 

        FROM dbo.FactInternetSales 

        GROUP BY YEAR(DueDate) , MONTH(DueDate) 

) , 

    MFRS AS (SELECT  

        YEAR(DueDate) as SALEYEAR, 

        MONTH(DueDate) as SALEMONTH, 

        SUM(SalesAmount) as Monthly_Resell_Sale_Amount 

        FROM dbo.FactResellerSales 

        GROUP BY YEAR(DueDate) , MONTH(DueDate) 

) 

SELECT     

    A.SALEYEAR, 

    A.SALEMONTH, 

    A.Monthly_Internet_Sale_Amount, 

    B.Monthly_Resell_Sale_Amount 

    FROM MFIS as A  

    FULL OUTER JOIN MFRS as B ON A.SALEMONTH=B.SALEMONTH AND A.SALEYEAR=B.SALEYEAR 

ORDER BY A.SALEYEAR, A.SALEMONTH 

-- Bài chữa làm đúng 

/*Lưu ý khi có nhiều hơn 1 CTE trong mệnh đề thì viết syntax như sau:  

 

WITH Name_CTE_1 AS ( 

SELECT statement 

) 

, Name_CTE_2 AS ( 

SELECT statement 

)  

 

SELECT statement 

* / 