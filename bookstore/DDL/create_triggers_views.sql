-- -----------------------------------------------------
--  3. Create a stored procedure that takes the start and end dates of the sales and display
-- all the sales transactions between the start and the end dates.

DELIMITER //
CREATE PROCEDURE SelectAllOrders(IN start_date date, IN end_date date)
	BEGIN
		SELECT * FROM orders
		WHERE purchased_date >= start_date
        AND purchased_date <= end_date;
	END;

-- Test the stored procedure
CALL SelectAllOrders('2020-01-01', '2020-10-31');

-- -----------------------------------------------------
-- 4. Create a view that shows the total number of items a customer buys FROM the business in October 2020
-- along with the total price (use group by)
-- -----------------------------------------------------

CREATE OR REPLACE VIEW october_purchases AS
SELECT customer.name,
		SUM(orders.quantity) AS 'quanity_purchased',
        SUM(orders.price) AS 'total_cost'
FROM orders
INNER JOIN customer
ON customer.id = orders.customer_id
WHERE MONTH(orders.purchased_date) = 10
GROUP BY customer.name;

-- Ensure View works
SELECT * FROM october_purchases;

-- -----------------------------------------------------
-- 5. Create a trigger that adjusts the stock level every time a product is sold.
-- -----------------------------------------------------

-- Create the Trigger

DELIMITER //
CREATE TRIGGER stock_level_adjustment
AFTER INSERT
ON orders FOR EACH ROW
BEGIN
     UPDATE book SET book.stock_quantity=(book.stock_quantity - NEW.quantity)
     WHERE book.id=New.book_id;
END;

SHOW TRIGGERS;
