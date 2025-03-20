-- TASK 1
-- EMPLOOYEE DATA ANALYST
-- 1.  TOTAL NUMBER OF EMPLOYEE

SELECT COUNT(*) AS "total employees"FROM employees;

-- INTERPRETATION -- These are the total employees.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 1
-- 2.  BASIC INFORMATION OF EMPLOYEES

SELECT employeeNumber, lastName, firstName, email, officeCode, jobTitle FROM employees;

-- INTERPRETATION -- These are the basic information of employees.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 1
-- 3.  JOB TITLE AND COUNT OF EMPLOYEES

SELECT jobtitle, COUNT(employeeNumber) AS "total employees" FROM employees
GROUP BY jobtitle;

-- INTERPRETATION -- These are the jobtitle and count of the employees in it.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 1
-- 4.  EMPLOYEE WHO HAS NO MANAGER 

SELECT employeeNumber, firstname, lastname, reportsTo FROM employees
WHERE reportsTo IS NULL;

-- This is the employee who has no manager.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 1
-- 5.  TOTAL SALES BY EACH SALES REPRESENTATIVE

SELECT c.salesRepEmployeeNumber, firstname, lastname, SUM(p.amount) AS "total amount" FROM 
employees e JOIN customers c
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p
ON c.customerNumber = p.customerNumber
GROUP BY c.salesRepEmployeeNumber
ORDER BY SUM(p.amount) DESC;

-- INTERPRETATION -- These are the sales representative and the total sales. The 1370 salesRepEmployeeNumber Gerard has the highest total sales.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 1
-- 6.  MAXIMUM TOTAL SALES BY SALES REPRESENTATIVE

SELECT c.salesRepEmployeeNumber, firstname, lastname, SUM(p.amount) AS total_amount FROM 
employees e JOIN customers c
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN payments p
ON c.customerNumber = p.customerNumber
GROUP BY c.salesRepEmployeeNumber
ORDER BY total_amount DESC
LIMIT 1; 

-- INTERPRETATION -- These are the sales representative and the maximum total sales.  The 1370 salesRepEmployeeNumber Gerard has the highest total sales.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 1
-- 7.  EMPLOYEE GREATER THAN AVERAGE AMOUNT FOR OFFICE

SELECT e.employeeNumber, e.firstname, e.lastname, os.officecode, p.amount FROM 
employees e JOIN offices os
ON e.officeCode = os.officeCode
JOIN customers cs
ON os.country = cs.country
JOIN payments p
ON cs.customerNumber = p.customerNumber 
WHERE amount > ( SELECT AVG(amount) AS "amount" FROM 
                 employees e JOIN offices o
                 ON e.officeCode = o.officeCode
				 JOIN customers cs
				 ON o.country = cs.country
                 JOIN payments p
				 ON cs.customerNumber = p.customerNumber 
                 WHERE o.officeCode = os.officeCode
                 GROUP BY o.officecode );

-- INTERPRETATION -- These are the employeeName who has greater than average amount of office.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- ORDER DATA ANALYST
-- 1.  ORDER AMOUNT FOR EACH CUSTOMER

SELECT c.customerNumber, c.customerName, AVG(amount) AS "amount" FROM 
customers c JOIN payments p
ON c.customerNumber = p.customerNumber
GROUP BY c.customerNumber;

-- INTERPRETATION -- These are the customer and order amount.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 2.  NUMBER OF ORDER PLACED IN MONTH

SELECT YEAR(orderDate) AS yr, MONTH(orderDate) AS mon, COUNT(orderNumber) AS total_order FROM orders
GROUP BY YEAR(orderDate), MONTH(orderDate);

-- INTERPRETATION -- These are the months and number of order placed in it.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 3.  ORDERNUMBER STILL SHIPMENT PENDING

SELECT orderNumber FROM orders
WHERE status = 'pending';

-- INTERPRETATION -- These are the orders has the status of pending.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 4.  ORDERS WITH CUSTOMER DETAILS

SELECT * FROM 
orders o JOIN customers c
ON o.customerNumber = c.customerNumber;

-- INTERPRETATION -- These are the orders and their customer details.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 5.  MOST RECENT ORDER PLACED

SELECT * FROM orders
WHERE orderDate = ( SELECT MAX(orderDate) FROM orders );

-- INTERPRETATION -- These are the recent order placed.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 2
-- 6.  ORDER DATE AND AMOUNT

SELECT orderDate, SUM(amount) AS "total amount" FROM 
orders o JOIN customers cs
ON o.customerNumber = cs.customerNumber
JOIN payments p
ON cs.customerNumber = p.customerNumber
GROUP BY orderDate;

-- INTERPRETATION -- These are the orderDate and the amount.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 7.  HIGHEST VALUE ORDER BY SALES


SELECT od.orderNumber, SUM(od.quantityOrdered * od.priceEach) AS totalSales FROM orderdetails od
GROUP BY od.orderNumber
ORDER BY totalSales DESC
LIMIT 1;


-- INTERPREATATION -- These are the higher value order by their sales.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 8.  ORDER WITH ORDERDETAILS

SELECT * FROM 
orders o JOIN orderdetails od
ON o.orderNumber = od.orderNumber;

-- INTERPRETATION -- These are the order with their order details.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 9.  PRODUCT ORDERED BY MAXIMUM

SELECT productCode, COUNT(productCode) AS torder FROM orderdetails
GROUP BY productCode
ORDER BY torder DESC
LIMIT 1;

-- INTERPRETATION -- These are the product that ordered maximum number.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 10.  REVENUE FOR EACH ORDER

SELECT o.orderNumber, SUM( quantityOrdered * priceEach ) AS revenue FROM 
orders o JOIN orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber;

-- INTERPRETATION -- These are the revenue for each order.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 11. HIGHEST REVENUE OF ORDER

SELECT o.orderNumber, SUM( quantityOrdered * priceEach ) AS revenue FROM
orders o JOIN orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber
ORDER BY revenue DESC
LIMIT 1;

-- INTERPRETATION -- These are the order with highest revenue.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 12.  ORDER WITH PRODUCT DETAILS

SELECT * FROM 
orders o JOIN orderdetails od
ON o.orderNumber = od.orderNumber
JOIN products p
ON od.productCode = p.productCode;

-- INTERPRETATION -- These are orders with product details.
-- _________________________________________________________________________________________________________________________________________________________________


-- TASK 2
-- 13.  ORDER WITH DELAYED SHIPPING

SELECT * FROM orders
WHERE shippedDate > requiredDate;

-- INTERPRETATION -- These are the order with delayed shipping.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 2
-- 14.  ORDER AND PRODUCT


SELECT od1.productCode, od2.productCode, COUNT(*) AS "total" FROM 
orderdetails od1 JOIN orderdetails od2
ON od1.orderNumber = od2.orderNumber
AND od1.productCode < od2.productCode
GROUP BY od1.productCode, od2.productCode
LIMIT 1;

-- INTERPRETATION -- These are the product highest in the orders.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 3
-- 15.  REVENUE OF TOP 10

SELECT o.orderNumber, SUM( quantityOrdered * priceEach ) AS revenue FROM
orders o JOIN orderdetails od
ON o.orderNumber = od.orderNumber
GROUP BY o.orderNumber
ORDER BY revenue DESC
LIMIT 10;
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 3
-- 16.  UPDATES THE CREDITLIMIT

DELIMITER $$

CREATE TRIGGER update_credit_limit_after_order
AFTER INSERT ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE totalOrderAmount DECIMAL(10, 2);
 
    SELECT SUM(od.quantityOrdered * od.priceEach) INTO totalOrderAmount
    FROM orderdetails od
    WHERE od.orderNumber = NEW.orderNumber;

    UPDATE customers
    SET creditLimit = creditLimit - totalOrderAmount
    WHERE customerNumber = (SELECT customerNumber FROM orders WHERE orderNumber = NEW.orderNumber);
END $$

DELIMITER ;

DROP TRIGGER update_credit_limit_after_order;

SELECT * FROM customers;
SELECT * FROM customers
WHERE customerNumber = 114;

SELECT * FROM orders;
desc orders;
SHOW CREATE TABLE orders;
SELECT * FROM orderdetails;
desc orderdetails;

UPDATE customers 
SET creditLimit = 21000.00
WHERE customerNumber = 103;
UPDATE customers 
SET creditLimit = 71800.00
WHERE customerNumber = 112;
INSERT INTO orderdetails(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES(10428, 'S18_1749', 10, 136.00, 3);
INSERT INTO orders (orderNumber, orderDate, requiredDate, status, customerNumber)
VALUES(10428, '2024-12-22', '2024-12-28', 'Inprocess', 114 );


-- INTERPRETATION -- It updates the credilimit automatically.
-- _________________________________________________________________________________________________________________________________________________________________

-- TASK 3
-- 17.  CREATING LOG TABLE

CREATE TABLE product_quantity_log (
    logID INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(15),
    changeType VARCHAR(10),
    quantityChanged INT,
    changeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER log_product_quantity_insert
AFTER INSERT ON orderdetails
FOR EACH ROW
BEGIN
    INSERT INTO product_quantity_log (productCode, changeType, quantityChanged)
    VALUES (NEW.productCode, 'INSERT', NEW.quantityOrdered);
END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER log_product_quantity_delete
AFTER DELETE ON orderdetails
FOR EACH ROW
BEGIN
    INSERT INTO product_quantity_log (productCode, changeType, quantityChanged)
    VALUES (OLD.productCode, 'DELETE', OLD.quantityOrdered);
END $$

DELIMITER ;


INSERT INTO orderdetails (orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber)
VALUES (10100, 'S10_1678', 10, 100, 1);


DELETE FROM orderdetails WHERE orderNumber = 10100 AND productCode = 'S10_1678';


SELECT * FROM product_quantity_log;


-- INTERPRETATION -- The Creating log table for insert and update.
-- _________________________________________________________________________________________________________________________________________________________________
