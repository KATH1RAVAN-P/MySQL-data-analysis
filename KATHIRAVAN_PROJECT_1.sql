SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM productlines;
SELECT * FROM products;


-- _____________________________________________________________________________________________________________________________________________________--
-- TASK 1
-- CUSTOMER DATA ANALYSIS

-- 1.  Top 10 customers by credit limit

SELECT customerName, creditLimit FROM customers
ORDER BY creditLimit DESC
LIMIT 10;

-- INTERPRETATION -- These are the top 10 customerName by their credit limit.
-- _____________________________________________________________________________________________________________________________________________________--


-- TASK 1
-- 2.  AVERAGE CREDIT LIMIT BY COUNTRY


SELECT country, AVG(creditLimit) AS "average credit " FROM customers
GROUP BY country
ORDER BY AVG(creditLimit) DESC ;

-- INTERPRETATION -- These are the average credit limit for the country. Denmark has the highest creditLimit. 
-- _____________________________________________________________________________________________________________________________________________________--


-- TASK 1
-- 3.  CUSTOMER BY STATE


SELECT state, COUNT( DISTINCT customerName) AS "customer total" FROM customers
GROUP BY state
HAVING state IS NOT NULL
ORDER BY COUNT( DISTINCT customerName) DESC;

-- INTERPRETATION -- These are the state along with their customer count. CA state has the highest. 
-- _____________________________________________________________________________________________________________________________________________________--

-- TASK 1
-- 4.  CUSTOMER WHO HAVE NOT PLACED ANY ORDER

SELECT c.customerName, o.customerNumber, o.orderNumber  FROM 
customers c LEFT JOIN orders o
ON c.customerNumber = o.customerNumber
WHERE o.orderNumber IS NULL;

-- INTERPRETATION -- These are the customers who have not placed any order
-- _____________________________________________________________________________________________________________________________________________________--

-- TASK 1
-- 5.  CUSTOMER BY TOTAL SALES


SELECT o.customerNumber, c.customerName, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM orders o JOIN orderdetails od 
ON o.orderNumber = od.orderNumber
JOIN customers c 
ON o.customerNumber = c.customerNumber
GROUP BY o.customerNumber, c.customerName
ORDER BY totalSales DESC;

-- INTERPRETATION -- These are the customer with their total sales. 'Euro+ Shopping Channel' has the highest sales and 'Boards & Toys Co.' has the low sales.
-- _____________________________________________________________________________________________________________________________________________________--

-- TASK 1
-- 6.  CUSTOMER WITH SALES REPRESEN

SELECT c.customerName, CONCAT( e.firstName , " ", e.lastName) AS "sales_rep"FROM 
customers c JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber;

-- INTERPRETATION -- These are the customerName and their sales representative.
-- _____________________________________________________________________________________________________________________________________________________--

-- TASK 1
-- 7.  CUSTOMER DETAILS AND THEIR RECENT PAYMENTS



SELECT * FROM 
customers c JOIN payments p
ON c.customerNumber = p.customerNumber
WHERE p.paymentDate = (SELECT MAX(paymentDate) AS "recent" FROM payments
					   WHERE c.customerNumber = customerNumber
                       GROUP BY customerNumber);
                       
-- INTERPRETATION-- These are the customer details along with their recent payments details                        
 -- _____________________________________________________________________________________________________________________________________________________--
                      
-- TASK 1
-- 8.  CUSTOMER EXCIDED THE CREDITLIMIT


SELECT c.customerNumber, c.customerName, c.creditLimit, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.customerNumber, c.customerName, c.creditLimit
HAVING totalSales > c.creditLimit
ORDER BY totalSales DESC;


-- INTERPRETATION -- These are the customer who exceeds the creditLimit
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 1
-- 9.  CUSTOMERNAME FOR SPECIFIC PRODUCTLINE


SELECT o.orderNumber, pd.productCode, pd.productName, od.customerNumber, c.customerName, p.productLine FROM 
products pd JOIN  productlines p
ON pd.productLine = p.productLine
JOIN orderdetails o
ON pd.productCode = o.productCode
JOIN orders od
ON o.orderNumber = od.orderNumber
JOIN customers c
ON c.customerNumber = od.customerNumber;

-- INTERPRETATION -- These are the customerName for specific productLine
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK
-- 10.  CUSTOMERNAME ORDERED EXPENSIVE PRODUCT


SELECT DISTINCT customers.customerName, products.productName FROM 
products JOIN productlines
ON products.productLine = productLines.productLine
JOIN orderdetails
ON orderdetails.productCode = products.productCode
JOIN orders
ON orders.orderNumber = orderdetails.orderNumber
JOIN customers
ON customers.customerNumber = orders.customerNumber
WHERE products.productName =( SELECT ProductName FROM products
							  WHERE MSRP = ( SELECT MAX(MSRP) AS "expensive" FROM products ) );
                              
-- INTERPRETATION -- These are the customerName who ordered expensive product. 27 csutomers ordered.
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 2
-- OFFICE DATA ANALYST

-- 1.  OFFICE WITH THEIR TOTAL EMPLOYEES

SELECT officeCode, COUNT(employeeNumber) AS "total_employee"FROM employees
GROUP BY officeCode
ORDER BY total_employee DESC;

-- INTERPRETATION -- These are the office and their total employees. OfficeCode 1 has highest number of employees.
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 2
-- 2.  OFFICE WITH LESS THAN CERTAIN EMPLOYEES

SELECT * FROM employees;
SELECT officeCode, COUNT(employeeNumber) AS "total_employees" FROM employees
GROUP BY officeCode
HAVING COUNT(employeeNumber) < (SELECT AVG(total_employee) FROM ( SELECT officeCode, COUNT(employeeNumber) AS "total_employee" FROM employees
												                  GROUP BY officeCode ) AS certain_number) ;
														
-- INTERPRETATION -- These are the office with less than certain number of employees.
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 2
-- 3.  OFFICE CODE WITH TERRITORY


SELECT officeCode, territory FROM offices;	

-- These are the office along with their territory
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 2
-- 4.  OFFICE WITH NO EMPLOYEES

SELECT o.officeCode, firstname, lastname FROM 
offices o LEFT JOIN employees e
ON o.officeCode = e.officeCode
WHERE firstname IS NULL OR lastname IS NULL;

-- INTERPRETATION -- These are the office with no employees.
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 2
-- 5.  OFFICE WITH HIGHEST SALES

SELECT o.officeCode, o.city AS officeCity, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM offices o JOIN employees e 
ON o.officeCode = e.officeCode
JOIN customers c 
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders ord 
ON c.customerNumber = ord.customerNumber
JOIN orderdetails od 
ON ord.orderNumber = od.orderNumber
GROUP BY o.officeCode, o.city
ORDER BY totalSales DESC
LIMIT 1;

-- INTERPRETATION -- These are the office with the highest sales amount. 4 Paris has the highest.
 -- _____________________________________________________________________________________________________________________________________________________--



-- TASK 2
-- 6.  OFFICE WITH HIGHEST NUMBER OF EMPLOYEES

SELECT officeCode, COUNT(employeeNumber) AS "total_employee" FROM employees
GROUP BY officeCode
ORDER BY COUNT(employeeNumber) DESC
LIMIT 1;

-- INTERPRETATION -- These are the office with highest number of employees.
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 2
-- 7.  OFFICE WITH AVERAGE CREDIT LIMIT

SELECT o.officeCode, o.city AS officeCity, AVG(c.creditLimit) AS averageCreditLimit
FROM offices o
JOIN employees e ON o.officeCode = e.officeCode
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY o.officeCode, o.city
ORDER BY averageCreditLimit DESC;

-- INTERPRETATION -- These are the office with their average creditLimit. 6 Sydney has highest.
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 2
-- 8.  TOTAL NUMBER OF OFFICE BY COUNTRY

SELECT o.country, COUNT(officeCode) AS "total offices"FROM
offices o
GROUP BY o.country;

-- INTERPRETATION -- These are the country along with their offices count. USA has the highest.
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 3
-- PRODUCT DATA ANALYST
-- 1.  PRODUCTLINES AND NUMBER OF PRODUCT

SELECT productLine, COUNT(productName) AS "total_product" FROM products
GROUP BY productLine;

-- INTERPRETATION -- These are the productLines and their number of product.

 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 3
-- 2.  HIGHEST AVERAGE PRICE OF THE PRODUCTLINE

SELECT productLine, AVG(buyPrice) AS "average price"FROM products
GROUP BY productLine
ORDER BY AVG(buyPrice) DESC
LIMIT 1;

-- INTERPRETATION -- The productLine which has highest average price.
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 3
-- 3.  PRODUCT WHERE MSRP BETWEEN 50 AND 100

SELECT productName FROM products
WHERE MSRP BETWEEN 50 AND 100;

-- INTERPRETATION -- These are the product where MSRP between 50 and 100.
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 3
-- 4.  PRODUCTLINES AND SALES

SELECT productLine, SUM(quantityOrdered * priceEach) AS "total_sales" FROM 
products JOIN orderdetails
ON products.productCode = orderdetails.productCode
GROUP BY productLine;

-- INTERPRETATION -- These are the productLines and total sales.
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK
-- 5.  THE PRODUCT WHERE QUANTITYINSTOCK IS LESS THAN THRESHOLD

SELECT productCode, productName, quantityInStock, buyPrice FROM products
WHERE quantityInStock < 10;

-- INTERPRETATION -- These are the productName where the quantityInstock is lesser than threshold value of 10
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 3
-- 6.  MOST EXPENSIVE PRODUCT BASED ON MSRP

SELECT productName, MSRP FROM products
WHERE MSRP = ( SELECT MAX(MSRP) FROM products ) ;

-- INTERPRETATION -- These are most expensive product by MSRP
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 3
-- 7.  PRODUCT BY TOTAL SALES


SELECT p.productCode, p.productName, SUM( o.quantityOrdered * o.priceEach ) AS "total" FROM 
products p JOIN orderdetails o
ON p.productCode = o.productCode
GROUP BY p.productCode;

-- These are the products and their total sales
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 3
-- 8.  PRODUCT AND TOTAL QUANTITY ORDERED


DELIMITER $$

CREATE PROCEDURE highest_quantity ( IN num INT )
BEGIN
SELECT p.productCode, p.productName, SUM( o.quantityOrdered  ) AS "total" FROM 
products p JOIN orderdetails o
ON p.productCode = o.productCode
GROUP BY p.productCode
ORDER BY total DESC
LIMIT Num;
END $$

DELIMITER ;

CALL highest_quantity(10);

-- INTERPRETATION -- These are the product and their total quantity ordered.
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 3
-- 9.  PRODUCT WHERE THE QUANTITYINSTOCK IS LESSES THAN THRESHOLD AND PRODUCTLINE IS CLASSIC CARS AND MOTORCYCLE

SELECT productCode, productName, quantityInStock, productLine, buyPrice FROM products
WHERE productLine IN ( 'Motorcycles', 'Classic Cars')
AND quantityInStock < 10;


-- INTERPRETATION -- These are the productName where the quantityInstock is lesser than threshold value of 10 Where the productLine is Classic Cars and Motorcycles
 -- _____________________________________________________________________________________________________________________________________________________--


-- TASK 3
-- 10.  PRODUCT ORDERED BY MORE THAN 10 CUSTOMER


SELECT productName, COUNT( DISTINCT cs.customerName) AS "total_customer" FROM
products p JOIN orderdetails o
ON p.productCode = o.productCode
JOIN orders od
ON o.orderNumber = od.orderNumber
JOIN customers cs
ON od.customerNumber = cs.customerNumber
GROUP BY productName
HAVING total_customer > 10;

-- INTERPRETATION -- These are the products which is ordered by more than 10 customers.
 -- _____________________________________________________________________________________________________________________________________________________--

-- TASK 3
-- 11.  PRODUCTNAME WHICH IS HIGHER THAN AVERAGE ORDER FOR EACH PRODUCTLINE

SELECT productLine, productName, quantityOrdered FROM
products p JOIN orderdetails o
ON p.productCode = o.productCode
JOIN orders od
ON o.orderNumber = od.orderNumber
JOIN customers cs
ON od.customerNumber = cs.customerNumber
WHERE quantityOrdered > ( SELECT ROUND(AVG(quantityOrdered)) AS "avg" FROM 
                          products p JOIN orderdetails o
						  ON p.productCode = o.productCode
                          WHERE productLine = p.productLine
                           );
                           
-- INTERPRETATION -- These are the productName which is higher than the average order by productLine.

 -- _____________________________________________________________________________________________________________________________________________________--







