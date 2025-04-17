# 1. Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці orders відповідно для кожного поля запису з таблиці order_details.
SELECT 
    id,
    order_id,
    product_id,
    quantity,
    (SELECT 
            customer_id
        FROM
            orders
        WHERE
            orders.id = od.order_id) AS customer_id
FROM
    order_details od;

# 2. Напишіть SQL запит, який буде відображати таблицю order_details. Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
SELECT 
    *
FROM
    order_details od
WHERE
    (SELECT 
            shipper_id
        FROM
            orders
        WHERE
            orders.id = od.order_id) = 3;

#3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою quantity>10 з таблиці order_details. Для отриманих даних знайдіть середнє значення поля quantity — групувати слід за order_id.
SELECT 
    order_id, AVG(quantity) avg_quantity
FROM
    (SELECT 
        *
    FROM
        order_details
    WHERE
        quantity > 10) AS temp
GROUP BY order_id

#4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp. Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит за аналогією до того, як це зроблено в конспекті.
WITH temp_table AS (SELECT 
        *
    FROM
        order_details
    WHERE
        quantity > 10)

SELECT 
    order_id, AVG(quantity) avg_quantity
FROM
    temp_table
GROUP BY order_id

#5. Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
DROP FUNCTION IF EXISTS divQuantity;

DELIMITER //
CREATE FUNCTION divQuantity (quantity FLOAT, divider FLOAT)
RETURNS FLOAT
DETERMINISTIC
NO SQL
BEGIN
	DECLARE result FLOAT default 0;
    
	IF divider = 0
    THEN
		RETURN result;
	END IF;
    
    SET result = quantity / divider;
    
    RETURN result;

END //

DELIMITER ;

SELECT order_id, quantity, divQuantity(quantity, 10) as divided
FROM order_details;