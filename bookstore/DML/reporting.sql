/*
 ***********************************************
 PART 3: Logical and Physical Design
 ************************************************
 */



-- -----------------------------------------------------
-- 1. Show all the details of the products that have a price greater than 100.
-- -----------------------------------------------------



SELECT * FROM orders WHERE price > 100.00;


-- -----------------------------------------------------
-- 2. Show all the products along with the supplier detail who supplied the products.
-- -----------------------------------------------------

SELECT book.title,
		book.ISBN,
		book.published_date,
		publisher.name AS 'publisher_name',
        publisher.phone,
        publisher.address,
        publisher.email,
        publisher.website
FROM book
INNER JOIN publisher
ON book.publisher_id = publisher.id;




-- -----------------------------------------------------
--  3. Test the stored procedure that takes the start and end dates of the sales and display
-- all the sales transactions between the start and the end dates.

-- Test the stored procedure
CALL SelectAllOrders('2020-01-01', '2020-10-31');


-- -----------------------------------------------------
-- 4. Test the view that shows the total number of items a customer buys FROM the business in October 2020
-- along with the total price (use group by)
-- -----------------------------------------------------

-- Ensure View works
SELECT * FROM october_purchases;



-- -----------------------------------------------------
-- 5. Test trigger that adjusts the stock level every time a product is sold.
-- -----------------------------------------------------

-- Choose a record to test the trigger
SELECT stock_quantity, title FROM book WHERE id = 3;  -- returns 24


-- Insert a new record into orders for a book (use quantity = 2)
INSERT INTO orders(id, price, quantity, purchased_date, employee_id, customer_id, book_id)
VALUES (1001, 22.50, 2, '2020-10-27', 5, 109, 3);

-- Choose the same record that we modified.
-- We expect the stock-quantity to diminish by 2 (quantity in the INSERT)


SELECT stock_quantity, title FROM book WHERE id = 3; -- expected 28



-- -----------------------------------------------------
-- 6. Create a report of the annual sales (2020) of the business showing the total number
-- of products sold and the total price sold every month (use A group by with roll-up)
-- -----------------------------------------------------
SELECT MONTH(orders.purchased_date) AS 'Month',
		SUM(orders.price) AS 'Total_Price',
        SUM(orders.quantity) AS 'Total_Quantity'
FROM orders
GROUP BY MONTH(orders.purchased_date) WITH ROLLUP;




-- -----------------------------------------------------
-- 7. Display the growth in sales/services (as a percentage) for your business, FROM the 1st month of opening until now.
-- -----------------------------------------------------

WITH sales_growth AS (
	SELECT
	MONTH(purchased_date) AS months,
    SUM(price) AS sales
    FROM orders
    GROUP BY months
    )
SELECT
	sales_growth.*,
    (sales - LAG(sales) OVER(ORDER BY months)) / sales * 100 AS growth_in_sales
FROM sales_growth;


-- ------------------------------------------------------------------
-- 8. Delete all customers who never buy a product FROM the business.
-- ------------------------------------------------------------------

-- Disable safe mode. This allows us to do DELETES
SET SQL_SAFE_UPDATES = 0;

-- Count all distinct customers who have purchased an order using inner join on orders.customer_id and customer.id
SELECT count(distinct(customer_id))
FROM orders
INNER JOIN customer
ON orders.customer_id = customer.id;



-- Count all customers who are have not purchased an order using Left Join
SELECT count(*)
FROM customer
LEFT JOIN orders
ON orders.customer_id = customer.id
WHERE orders.customer_id is NULL;



-- Finally Delete the customers FROM above.
DELETE customer
FROM customer
LEFT JOIN orders
ON orders.customer_id = customer.id
WHERE orders.customer_id is NULL;

-- Count all customers who are have not purchased an order
-- Use subquery of an NOT IN clause (to show this can be done multiple ways)
-- Expect 0 as we deleted in
SELECT count(*)
FROM customer
WHERE customer.id NOT IN
(
	SELECT customer_id
	FROM orders
	INNER JOIN customer
	ON orders.customer_id = customer.id
);


