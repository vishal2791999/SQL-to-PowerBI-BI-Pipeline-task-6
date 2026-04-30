-- SQL BI Task 6 Complete Script

CREATE DATABASE BusinessDB;
USE BusinessDB;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Region VARCHAR(50),
    Segment VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

CREATE TABLE Sales (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Revenue DECIMAL(12,2),
    Profit DECIMAL(12,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Views
CREATE VIEW vw_CustomerKPIs AS
SELECT c.CustomerName, c.Region, c.Segment,
COUNT(DISTINCT s.OrderID) AS TotalOrders,
SUM(s.Revenue) AS TotalRevenue,
SUM(s.Profit) AS TotalProfit
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName, c.Region, c.Segment;

CREATE VIEW vw_MonthlyTrend AS
SELECT FORMAT(OrderDate,'yyyy-MM') AS Month,
SUM(Revenue) AS Revenue,
SUM(Profit) AS Profit
FROM Sales
GROUP BY FORMAT(OrderDate,'yyyy-MM');

-- Stored Procedure
CREATE PROCEDURE sp_MonthlySummary @ReportMonth VARCHAR(7)
AS
BEGIN
SELECT @ReportMonth AS ReportMonth,
SUM(Revenue) AS TotalRevenue,
SUM(Profit) AS TotalProfit
FROM Sales
WHERE FORMAT(OrderDate,'yyyy-MM') = @ReportMonth;
END;
