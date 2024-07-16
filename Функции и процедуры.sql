--1--
DELIMITER //
CREATE FUNCTION anniversary(db DATE) RETURNS INTEGER
BEGIN
    DECLARE age INT;
    SET age = YEAR(NOW()) - YEAR(db);
    IF age%5!=0 THEN
        RETURN NULL;
    END IF;
    RETURN age;
END //
DELIMITER ;

--2--
DELIMITER //
CREATE FUNCTION fio(second_name VARCHAR(255), first_name VARCHAR(255),third_name VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN 
    DECLARE short_fio VARCHAR(255);
    IF second_name IS NULL OR first_name IS NULL OR third_name IS NULL THEN
        RETURN '######';
    END IF;
        IF second_name = '' OR first_name = '' OR third_name = '' THEN
        RETURN '######';
    END IF;
    SET short_fio = CONCAT(second_name, ' ', LEFT(first_name, 1), '.', LEFT(third_name, 1), '.');
    RETURN short_fio;
END //
DELIMITER ;

--3--
DELIMITER //
CREATE FUNCTION income(id_salesman INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE rate_salesman DECIMAL(3,2);
    DECLARE whole_sum DECIMAL;
    DECLARE whole_income DECIMAL;
    SET rate_salesman = (SELECT `rate` FROM `salesmen` WHERE `id` = id_salesman LIMIT 1);
    SET whole_sum = (SELECT sum(`income`) FROM `sales` WHERE `salesman_id` = id_salesman );
    SET whole_income = rate_salesman * whole_sum;
    RETURN whole_income;
END //
DELIMITER ;

--4--
DELIMITER //
CREATE FUNCTION company_income(id_good INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE price DECIMAL(10,2);
    DECLARE quantity INT;
    DECLARE whole_income DECIMAL;
    SET price = (SELECT `cost` FROM `sales` WHERE `product_id` = id_good LIMIT 1);
    SET quantity = (SELECT sum(`qty`) FROM `sales` WHERE `product_id` = id_good );
    SET whole_income = price * quantity;
    RETURN whole_income;
END //
DELIMITER ;

--5--
DELIMITER //
CREATE PROCEDURE anniversary_men()
BEGIN 
    SELECT last_name, first_name, birth_date, YEAR(NOW()) - YEAR(birth_date) as age
    FROM salesmen
    WHERE (YEAR(NOW()) - YEAR(birth_date))%5=0;
END //
DELIMITER ;

--6--
DELIMITER //
CREATE PROCEDURE goods_in_groups(IN id INT)
BEGIN 
    SELECT p.name, g.name, p.plu, p.cost, p.available
    FROM products p
    JOIN groups g ON p.group_id = g.id
    WHERE id = group_id;
END //
DELIMITER ;

--7--
DELIMITER //
CREATE PROCEDURE good(IN good_name VARCHAR(255), time_sale INT)
BEGIN
    SET time_sale = IFNULL(time_sale, 7);
    SELECT p.name, s.date, CONCAT(sm.last_name, ' ', LEFT(sm.first_name, 1), '.', LEFT(sm.middle_name, 1), '.') as salesman, s.qty
    FROM sales s
    JOIN products p ON s.product_id = p.id
    JOIN salesmen sm ON s.salesman_id = sm.id
    WHERE p.name = good_name AND date BETWEEN NOW() - INTERVAL time_sale DAY AND NOW();
END //
DELIMITER ;

--8--
DELIMITER //
CREATE PROCEDURE price()
BEGIN
    DECLARE discrepancy INT;
    SET discrepancy = (SELECT count(*) FROM sales s JOIN products p ON s.product_id = p.id WHERE s.cost!=p.cost AND p.cost_changed_at < s.date);
    IF discrepancy = 0 THEN
        SELECT 'no discrepancies in price';
    ELSE
        SELECT p.name, p.cost, s.cost
        FROM sales s
        JOIN products p ON s.product_id = p.id
        WHERE s.cost!=p.cost;
    END IF;
END //
DELIMITER ;