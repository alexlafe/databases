# Задача 34

CREATE TABLE `Поставка` (
    `КодТовара` INTEGER, 
    `КодПоставщика` INTEGER, 
    `Количество` INTEGER, 
    `НазвТовара` VARCHAR(255), 
    `НазвПоставщика` VARCHAR(255)
) DEFAULT CHARSET=utf8;

INSERT INTO `Поставка` VALUES
    (1, 1, 7, "Телевизор", "ИП Жмышенко"),
    (1, 2, 10, "Телевизор", "ООО ООО"),
    (2, 1, 3, "Холодильник", "ИП Жмышенко"),
    (2, 2, 1, "Холодильник", "ООО ООО"),
    (3, 1, 2, "Микроволновка", "ИП Жмышенко");

CREATE TABLE `Поставщик` (
    `Код` INTEGER AUTO_INCREMENT,
    `Назв` VARCHAR(255),
    PRIMARY KEY(`Код`)
) DEFAULT CHARSET=utf8;

CREATE TABLE `Товар` (
    `Код` INTEGER AUTO_INCREMENT,
    `Назв` VARCHAR(255),
    PRIMARY KEY(`Код`)
) DEFAULT CHARSET=utf8;

CREATE TABLE `Поставка_новая`(
    `Код` INTEGER AUTO_INCREMENT,
    `КодТовара` INTEGER,
    `КодПоставщика` INTEGER,
    PRIMARY KEY(`Код`),
    FOREIGN KEY (`КодТовара`) REFERENCES `Товар` (`Код`),
    FOREIGN KEY (`КодПоставщика`) REFERENCES `Поставщик` (`Код`)
) DEFAULT CHARSET=utf8;

INSERT INTO `Поставщик` (`Назв`) SELECT DISTINCT `НазвПоставщика` FROM `Поставка`; 
INSERT INTO `Товар` (`Назв`) SELECT DISTINCT `НазвТовара` FROM `Поставка`;
INSERT INTO `Поставка_новая` (`КодТовара`, `КодПоставщика`) SELECT `КодТовара`, `КодПоставщика` FROM `Поставка`;

DROP TABLE `Поставка`;
ALTER TABLE `Поставка_новая` RENAME `Поставка`;
