SELECT * FROM categories;
SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM products;
SELECT * FROM shippers;
SELECT * FROM suppliers;

# 5 best selling products
SELECT
	p.ProductID,
    p.ProductName,
    COUNT(*) AS count_productid
FROM
	orderdetails od
		JOIN
	products p ON od.productid = p.productid
GROUP BY productid
ORDER BY count_productid DESC
LIMIT 5;

# best selling categories
SELECT
	p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.Price,
    od.Quantity    
FROM
	orderdetails od
		JOIN
	products p ON od.productID = p.productID
		JOIN
    categories c ON p.CategoryID = c.CategoryID;
    
SELECT
    c.CategoryName,
    SUM(od.Quantity) AS total_quantity   
FROM
	orderdetails od
		JOIN
	products p ON od.productID = p.productID
		JOIN
    categories c ON p.CategoryID = c.CategoryID
GROUP BY c.categoryname
ORDER BY total_quantity DESC;

# best selling dairy products
SELECT
	p.ProductID,
    p.ProductName,
    c.CategoryName,
    p.Price,
    od.Quantity    
FROM
	orderdetails od
		JOIN
	products p ON od.productID = p.productID
		JOIN
    categories c ON p.CategoryID = c.CategoryID
WHERE c.categoryname LIKE '%dairy%';

SELECT
    p.ProductName,
    SUM(od.Quantity) AS total_quantity   
FROM
	orderdetails od
		JOIN
	products p ON od.productID = p.productID
		JOIN
    categories c ON p.CategoryID = c.CategoryID
WHERE c.categoryname = 'Dairy Products'
GROUP BY p.productname
ORDER BY total_quantity DESC;
-- using CTE
WITH cte AS (
SELECT
    p.ProductName,
    SUM(od.Quantity*p.price) AS sales  
FROM
	orderdetails od
		JOIN
	products p ON od.productID = p.productID
		JOIN
    categories c ON p.CategoryID = c.CategoryID
WHERE c.categoryname = 'Dairy Products'
GROUP BY p.ProductName
ORDER BY sales DESC)
SELECT
	productname,
    sales
FROM
	cte c
WHERE sales = (SELECT MAX(sales) FROM cte)
GROUP BY c.productname;
-- using subquery
SELECT
	a.ProductName,
    sales
FROM
(SELECT
    p.ProductName,
    SUM(od.Quantity*p.price) AS sales  
FROM
	orderdetails od
		JOIN
	products p ON od.productID = p.productID
		JOIN
    categories c ON p.CategoryID = c.CategoryID
WHERE c.categoryname = 'Dairy Products'
GROUP BY p.ProductName) AS a
WHERE
	sales = (SELECT MAX(a.sales) FROM (SELECT
    p.ProductName,
    SUM(od.Quantity*p.price) AS sales  
FROM
	orderdetails od
		JOIN
	products p ON od.productID = p.productID
		JOIN
    categories c ON p.CategoryID = c.CategoryID
WHERE c.categoryname = 'Dairy Products'
GROUP BY p.ProductName) AS a);

