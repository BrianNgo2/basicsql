Use AdventureWorksDW2019  

 

/* Ex1. Write a query select top 10 percent customer informartion.  

Retrieve CustomerKey, Title, Gender columns only */ 

-- Your code here  

select top 10 percent  

[CustomerKey], 

[Title], 

[Gender] 

from dbo.DimCustomer 

/* Ex2. Write a query select top 10 percent of the heaviest products by Weight column.  

Retrieve EnglishProductName, Weight and Size column */  

-- Your code here  

select top 10 percent [Weight], 

[EnglishProductName],  

[Size] 

from dbo.DimProduct 

Order by [Weight] DESC 

/* Ex3: Select the fields below from table DimEmployee: 

EmployeeKey, FirstName, LastName, BaseRate, VacationHours, SickLeaveHours 

And then: 

Generate a new field named “FullName” which is equal to: FirstName + ‘ ’ + LastName 

Generate a new field named “VacationLeavePay” which is equal to: BaseRate * VacationHours  

Generate a new field named “SickLeavePay” which is equal to: SickLeaveHours * VacationHours  

Generate a new field named “TotalLeavePay” which is equal to: VacationLeavePay+SickLeavePay 

*/  

-- Your code here  

Select [EmployeeKey], 

[FirstName], 

[LastName], 

[BaseRate], 

[VacationHours], 

[SickLeaveHours], 

Concat([FirstName],' ',[LastName]) as [FullName], 

[BaseRate]*[VacationHours] as [VacationLeavePay], 

[SickLeaveHours]*[VacationHours] as [SickLeavePay], 

[BaseRate]*[VacationHours]+[SickLeaveHours]*[VacationHours] as [TotalLeavePay] 

from dbo.DimEmployee  

 

/* Ex4: Write a query to get SalesOrderNumber, ProductKey, OrderDate from FactInternetSales then caculate: 

- Total Revenue equal to OrderQuantity*UnitPrice 

- Total Cost equal to ProductStandardCost + DiscountAmount 

- Profit equal to Total Revenue - Total Cost 

- Profit margin equal (Total Revenue - Total Cost)/Total Revenue 

*/ 

-- Your code here  

Select SalesOrderNumber, 

ProductKey, 

OrderDate, 

OrderQuantity*UnitPrice as 'Total Revenue', 

ProductStandardCost+DiscountAmount as 'Total Cost', 

OrderQuantity*UnitPrice-( ProductStandardCost+DiscountAmount) as Profit, 

(OrderQuantity*UnitPrice-ProductStandardCost+DiscountAmount)/(OrderQuantity*Unitprice) as 'Profit margin' 

From dbo.FactInternetSales 