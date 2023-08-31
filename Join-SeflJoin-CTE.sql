 /* From dbo.DimProduct, dbo.DimPromotion, dbo.FactInternetSales,  

Write a query display ProductKey, EnglishProductName which has Discount Pct >= 20%*/ 

-- Your code here  

SELECT  

P.Productkey 

, P.EnglishProductName 

, DPm.DiscountPct 

, FORMAT(DPm.DiscountPct, 'p' )  AS PCT   

From dbo.DimProduct AS P  

LEFT JOIN dbo.FactInternetSales AS FIS ON FIS.ProductKey=P.ProductKey 

LEFT JOIN dbo.DimPromotion AS DPm ON DPm.PromotionKey=FIS.PromotionKey   

Where DPm.DiscountPct  >= 0.2 

---Bạn nên lấy bảng FactInternetSales làm chính nhé. để không bị mất mát dữ liệu giao dịch nhé 

 

/*From dbo.DimProduct and DimProductSubcategory, DimProductCategrory 

Write a query displaying the Product key, EnglishProductName, EnglishProductSubCategoryName , EnglishProductCategroyName columns of product which has EnglishProductCategoryName is 'Clothing'*/ 

-- Your code here  

SELECT  

P.ProductKey 

, P.EnglishProductName 

, DPS.EnglishProductSubcategoryName 

, DPC.EnglishProductCategoryName 

FROM Dbo.DimProduct AS P  

LEFT JOIN dbo.DimProductSubcategory AS DPS ON P.ProductSubcategoryKey=DPS.ProductSubcategoryKey 

LEFT JOIN dbo.DimProductCategory AS DPC ON DPS.ProductCategoryKey=DPC.ProductCategoryKey 

WHERE DPC.EnglishProductCategoryName = 'Clothing' 

 

--- Bailàm đúng 

 
 /*
From FactInternetSales, DimProduct  
Display ProductKey, EnglishProductName, ListPrice of products which never have been sold  
*/
-- Your code here  

SELECT  

ProductKey 

, EnglishProductName 

, ListPrice 

FROM Dbo.DimProduct 

WHERE ProductKey NOT IN (SELECT ProductKey FROM Dbo.FactInternetSales)  

 

 

-- Bài làm đúng 

/*

From DimDepartmentGroup, Write a query display DepartmentGroupName and 

their parent DepartmentGroupName  */

-- Your code here  

SELECT  

DDG.DepartmentGroupName 

, PDDG.DepartmentGroupName AS ParentDepartmentGroupName 

FROM dbo.DimDepartmentGroup AS DDG 

LEFT JOIN dbo.DimDepartmentGroup AS PDDG ON DDG.ParentDepartmentGroupKey=PDDG.DepartmentGroupKey 

 

-- Bài làm đúng 

 

/*From FactFinance, DimOrganization, DimScenario 

Write a query display OrganizationKey, OrganizationName, Parent OrganizationKey, Parent OrganizationName, Amount 

where ScenarioName is 'Actual'  

-- Your code here*/  

SELECT  

FFjDS.OrganizationKey 

, DOjPDO.OrganizationName 

, DOjPDO.ParentOrganizationKey 

, DOjPDO.ParentOrganizationName 

, FFjDS.Amount 

FROM 

(SELECT  

FF.OrganizationKey 

, FF.Amount 

, DS.ScenarioName 

FROM dbo.FactFinance AS FF 

LEFT JOIN dbo.DimScenario AS DS ON FF.ScenarioKey=DS.ScenarioKey 

WHERE ScenarioName = 'Actual') AS FFjDS 

LEFT JOIN ( 

SELECT 

DO.OrganizationKey, 

DO.OrganizationName, 

DO.ParentOrganizationKey, 

PDO.OrganizationName AS ParentOrganizationName 

FROM dbo.DimOrganization AS DO  

LEFT JOIN dbo.DimOrganization AS PDO ON DO.ParentOrganizationKey=PDO.OrganizationKey ) AS DOjPDO ON FFjDS.OrganizationKey=DOjPDO.OrganizationKey 

 

-- Bài làm đúng, nhưng bạn có thể viết tuần tự các JOIN là được nhé 
---CTE: 
/*
WITH temp_sale AS (  

    SELECT  

        ProductKey  

    FROM dbo.FactInternetSales  

    WHERE SalesAmount > 1000 )  

SELECT  

    ProductKey,  

    EnglishProductName,  

    Color  

FROM dbo.DimProduct  

WHERE ProductKey IN (SELECT ProductKey FROM temp_sale)
*/