CREATE TABLE additional_table(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_id INT UNSIGNED,
    updated_at TIMESTAMP,
    old_cost DECIMAL(10,2),
    new_cost DECIMAL(10,2),
    PRIMARY KEY(id)
);

--1--
DROP TRIGGER IF EXISTS `price_change`;
DELIMITER //
CREATE TRIGGER `price_change`
BEFORE UPDATE
ON `products`
FOR EACH ROW
BEGIN
    IF OLD.cost!=NEW.cost THEN
        SET NEW.cost_changed_at = NOW();
    END IF;
    INSERT INTO `additional_table` (name_id, updated_at, old_cost, new_cost) VALUES (NEW.id, NOW(), OLD.cost, NEW.cost);
END //
DELIMITER ;

--2--
DROP TRIGGER IF EXISTS `deleted_group`;
DELIMITER //
CREATE TRIGGER `deleted_group`
BEFORE DELETE
ON `groups`
FOR EACH ROW
BEGIN
    UPDATE `products` SET group_id = NULL, available = 0 WHERE group_id = OLD.id;
END //
DELIMITER ;