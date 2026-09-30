CREATE DATABASE BookVerse_DB;

USE BookVerse_DB;

CREATE TABLE Books
(
    Book_ID INT PRIMARY KEY,
    Title VARCHAR(250) NOT NULL,
    Author VARCHAR(150) NOT NULL,
    Genre VARCHAR(80),
    Published_Year YEAR,
    Price DECIMAL(10,2),
    Stock INT
);

DESCRIBE Books;

CREATE TABLE Customers
(
    Customer_ID INT PRIMARY KEY,
    Name VARCHAR(120),
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(20),
    City VARCHAR(100),
    Country VARCHAR(100)
);

DESCRIBE Customers;

CREATE TABLE Orders
(
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Book_ID INT,
    Order_Date DATE,
    Quantity INT,
    Total_Amount DECIMAL(10,2),

    CONSTRAINT FK_Order_Customer
        FOREIGN KEY(Customer_ID)
        REFERENCES Customers(Customer_ID),

    CONSTRAINT FK_Order_Book
        FOREIGN KEY(Book_ID)
        REFERENCES Books(Book_ID)
);

DESCRIBE Orders;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Validating the Data
-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) AS Total_Books
FROM Books;

SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT COUNT(*) AS Total_Orders
FROM Orders;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Checking Duplicate Primary Keys
-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT Book_ID, COUNT(*) AS Duplicate_Count
FROM Books
GROUP BY Book_ID
HAVING COUNT(*) > 1;

SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT Order_ID, COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Checking Missing Values
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT
    SUM(Book_ID IS NULL) AS Missing_Book_ID,
    SUM(Title IS NULL) AS Missing_Title,
    SUM(Author IS NULL) AS Missing_Author,
    SUM(Genre IS NULL) AS Missing_Genre,
    SUM(Published_Year IS NULL) AS Missing_Published_Year,
    SUM(Price IS NULL) AS Missing_Price,
    SUM(Stock IS NULL) AS Missing_Stock
FROM Books;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Name IS NULL) AS Missing_Name,
    SUM(Email IS NULL) AS Missing_Email,
    SUM(Phone IS NULL) AS Missing_Phone,
    SUM(City IS NULL) AS Missing_City,
    SUM(Country IS NULL) AS Missing_Country
FROM Customers;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    SUM(Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Book_ID IS NULL) AS Missing_Book_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Quantity IS NULL) AS Missing_Quantity,
    SUM(Total_Amount IS NULL) AS Missing_Total_Amount
FROM Orders;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Chacking Foreign-Key
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT o.*
FROM Orders o
LEFT JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

SELECT o.*
FROM Orders o
LEFT JOIN Books b
    ON o.Book_ID = b.Book_ID
WHERE b.Book_ID IS NULL;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Basic Data Exploration
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS Total_Books
FROM Books;

SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT COUNT(*) AS Total_Orders
FROM Orders;

SELECT DISTINCT Genre
FROM Books
ORDER BY Genre;

SELECT DISTINCT Country
FROM Customers
ORDER BY Country;

SELECT SUM(Quantity) AS Total_Quantity_Sold
FROM Orders;

SELECT ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM Orders;

SELECT ROUND(AVG(Total_Amount), 2) AS Average_Order_Value
FROM Orders;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Sales Performance Analysis
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT COUNT(*) AS Total_Orders
FROM Orders;

SELECT SUM(Quantity) AS Total_Units_Sold
FROM Orders;

SELECT ROUND(SUM(Total_Amount), 2) AS Total_Revenue
FROM Orders;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre
ORDER BY Revenue DESC
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Quantity) AS Units_Sold
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
ORDER BY Units_Sold DESC
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author
ORDER BY Revenue DESC
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Author,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Revenue DESC;

SELECT
    b.Genre,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Revenue DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Genre,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Revenue DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    COUNT(Order_ID) AS Number_of_Orders,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Total_Amount), 2) AS Revenue
FROM Orders
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Sales_Year,
    Sales_Month;

-- -----------------------------------------------------------------------------------------------------------------------------------
SELECT
    YEAR(Order_Date) AS Sales_Year,
    COUNT(Order_ID) AS Number_of_Orders,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Total_Amount), 2) AS Revenue
FROM Orders
GROUP BY YEAR(Order_Date)
ORDER BY Sales_Year;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Price
FROM Books
ORDER BY Price DESC
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title
HAVING SUM(o.Quantity) >= 20
ORDER BY Revenue DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Customer Purchasing Behaviour Analysis
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Number_of_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Number_of_Orders DESC;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.Customer_ID,
    c.Name,
    c.Country,
    COUNT(o.Order_ID) AS Number_of_Orders,
    ROUND(SUM(o.Total_Amount), 2) AS Total_Spending
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name,
    c.Country
ORDER BY Total_Spending DESC
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(o.Order_ID) AS Number_of_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(o.Order_ID) > 1
ORDER BY Number_of_Orders DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(*) AS Repeat_Customers
FROM
(
    SELECT Customer_ID
    FROM Orders
    GROUP BY Customer_ID
    HAVING COUNT(Order_ID) > 1
) AS RepeatCustomerList;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.Country,
    COUNT(DISTINCT c.Customer_ID) AS Number_of_Customers,
    COUNT(o.Order_ID) AS Number_of_Orders,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY Revenue DESC
LIMIT 10;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    ROUND(AVG(Customer_Total), 2) AS Average_Customer_Spending
FROM
(
    SELECT
        Customer_ID,
        SUM(Total_Amount) AS Customer_Total
    FROM Orders
    GROUP BY Customer_ID
) AS CustomerSpending;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.Customer_ID,
    c.Name,
    COUNT(DISTINCT b.Genre) AS Number_of_Genres
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
JOIN Books b
    ON o.Book_ID = b.Book_ID
GROUP BY
    c.Customer_ID,
    c.Name
HAVING COUNT(DISTINCT b.Genre) > 1
ORDER BY Number_of_Genres DESC
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.Customer_ID,
    c.Name,
    MIN(o.Order_Date) AS First_Order_Date,
    MAX(o.Order_Date) AS Latest_Order_Date,
    COUNT(o.Order_ID) AS Number_of_Orders,
    ROUND(SUM(o.Total_Amount), 2) AS Total_Spending
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name
ORDER BY Total_Spending DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Product & Genre Performance Analysis
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT
    b.Genre,
    COUNT(DISTINCT b.Book_ID) AS Number_of_Books,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Genre
ORDER BY Revenue DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price,
    b.Stock
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    COALESCE(SUM(o.Quantity), 0) AS Units_Sold
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author
ORDER BY Units_Sold ASC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Author,
    COUNT(DISTINCT b.Book_ID) AS Number_of_Books,
    COALESCE(SUM(o.Quantity), 0) AS Units_Sold,
    ROUND(COALESCE(SUM(o.Total_Amount), 0), 2) AS Revenue
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY b.Author
ORDER BY Revenue DESC;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Price,
    COALESCE(SUM(o.Quantity), 0) AS Units_Sold,
    ROUND(COALESCE(SUM(o.Total_Amount), 0), 2) AS Revenue
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Price
ORDER BY b.Price DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Inventory Analysis
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Stock
FROM Books
ORDER BY Stock ASC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Stock
FROM Books
WHERE Stock < 20
ORDER BY Stock ASC
LIMIT 10;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    Author,
    SUM(Stock) AS Total_Stock,
    ROUND(SUM(Price * Stock), 2) AS Inventory_Value
FROM Books
GROUP BY Author
ORDER BY Inventory_Value DESC;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    Book_ID,
    Title,
    Author,
    Genre,
    Stock,
    Price
FROM Books
WHERE Stock >= 80
ORDER BY Stock DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Sales + Inventory Analysis
-- ---------------------------------------------------------------------------------------------------------------------------------------

SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock,
    SUM(o.Quantity) AS Units_Sold,
    ROUND(SUM(o.Total_Amount), 2) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock
HAVING
    SUM(o.Quantity) >= 10
    AND b.Stock < 20
ORDER BY Units_Sold DESC;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS Units_Sold,
    ROUND(COALESCE(SUM(o.Total_Amount), 0), 2) AS Revenue
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Stock
HAVING
    b.Stock >= 50
    AND COALESCE(SUM(o.Quantity), 0) <= 5
ORDER BY b.Stock DESC
LIMIT 10;

-- ----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price,
    b.Stock,
    ROUND(b.Price * b.Stock, 2) AS Inventory_Value
FROM Books b
LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID
WHERE o.Book_ID IS NULL
  AND b.Stock > 0
ORDER BY Inventory_Value DESC
LIMIT 10;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Complete book-performance table
-- ---------------------------------------------------------------------------------------------------------------------------------------
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price,
    b.Stock,

    COALESCE(SUM(o.Quantity), 0) AS Units_Sold,

    ROUND(
        COALESCE(SUM(o.Total_Amount), 0),
        2
    ) AS Revenue,

    ROUND(
        b.Price * b.Stock,
        2
    ) AS Inventory_Value,

    CASE
        WHEN COALESCE(SUM(o.Quantity), 0) = 0
            THEN 'Never Ordered'

        WHEN COALESCE(SUM(o.Quantity), 0) >= 10
             AND b.Stock < 20
            THEN 'High Demand - Low Stock'

        WHEN COALESCE(SUM(o.Quantity), 0) <= 5
             AND b.Stock >= 50
            THEN 'Low Demand - High Stock'

        ELSE 'Normal'
    END AS Business_Status

FROM Books b

LEFT JOIN Orders o
    ON b.Book_ID = o.Book_ID

GROUP BY
    b.Book_ID,
    b.Title,
    b.Author,
    b.Genre,
    b.Price,
    b.Stock

ORDER BY Revenue DESC;

-- ---------------------------------------------------------------------------------------------------------------------------------------
-- Final Validation
-- ---------------------------------------------------------------------------------------------------------------------------------------

SHOW FULL TABLES;

SELECT COUNT(*) FROM Books;
SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Orders;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Insights for Presentation -
-- ----------------------------------------------------------------------------------------------------------------------------------------

-- 1. Top revenue-generating genre
SELECT genre, SUM(quantity * price) AS total_revenue
FROM orders
JOIN books ON orders.book_id = books.Book_ID
GROUP BY genre
ORDER BY total_revenue DESC
LIMIT 1;

-- 2. Top-selling book
SELECT title, SUM(quantity) AS total_sold
FROM orders
JOIN books ON orders.book_id = books.book_id
GROUP BY title
ORDER BY total_sold DESC
LIMIT 1;

-- 3. Highest-spending customer
SELECT customers.name, SUM(total_amount) AS total_spent
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY customers.name
ORDER BY total_spent DESC
LIMIT 1;

-- 4. Country with highest revenue
SELECT country, SUM(total_amount) AS total_revenue
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 1;

-- 5. Number of repeat customers
SELECT COUNT(*) AS repeat_customer_count
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(customer_id) > 1
) AS customer_counts;

-- 6. Number of never-ordered books
SELECT COUNT(*) AS never_ordered_count
FROM books
LEFT JOIN orders ON books.book_id = orders.book_id
WHERE orders.book_id IS NULL;

-- 7. Number of high-demand / low-stock books
SELECT COUNT(*) AS High_Demand_Low_Stock_Books
FROM (
    SELECT b.Book_ID
    FROM Books b
    JOIN Orders o
        ON b.Book_ID = o.Book_ID
    GROUP BY b.Book_ID, b.Stock
    HAVING
        SUM(o.Quantity) >= 10
        AND b.Stock < 20
) AS high_demand_low_stock;


