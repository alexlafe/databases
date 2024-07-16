# 1
# Из таблицы clients сделайте по каждому клиенту выборку года рождения;
SELECT name, lastname, YEAR(dbirth) as "Birth year" FROM clients LIMIT 10;

# 2
# Вычислите по каждому клиенту его текущий возраст относительно сегодняшней даты:
# Полных лет
SELECT name, lastname, TIMESTAMPDIFF(YEAR, dbirth, CURDATE()) as "Age" FROM clients LIMIT 10;
# Лет до конца текущего года
SELECT name, lastname, TIMESTAMPDIFF(YEAR, dbirth, CONCAT(YEAR(CURDATE()), '-12-31')) as Age FROM clients LIMIT 10;

# 3
# Подсчитайте сколько было/будет полных лет каждому клиенту на
# 8 декабря 1992 года
SELECT name, lastname, TIMESTAMPDIFF(YEAR, dbirth, '1992-12-8') as Age FROM clients WHERE TIMESTAMPDIFF(YEAR, dbirth, '1992-12-8') >= 0 LIMIT 10;
# 15 июля 2021 года
SELECT name, lastname, TIMESTAMPDIFF(YEAR, dbirth, '2021-07-15') as Age FROM clients WHERE TIMESTAMPDIFF(YEAR, dbirth, '2021-07-15') >= 0 LIMIT 10;

# 4
# Найдите клиентов, у которых планируется день рождения:
# В ближайшую неделю
SELECT name, lastname, dbirth FROM clients WHERE TIMESTAMPDIFF(DAY, CURDATE(), DATE_FORMAT(dbirth, CONCAT(YEAR(CURDATE()), '-%m-%d'))) between 0 and 7 LIMIT 100;
# В ближайшие две недели
SELECT name, lastname, dbirth FROM clients WHERE TIMESTAMPDIFF(DAY, CURDATE(), DATE_FORMAT(dbirth, CONCAT(YEAR(CURDATE()), '-%m-%d'))) between 0 and 14 LIMIT 100;
# До конца текущего месяца
SELECT name, lastname, dbirth FROM clients WHERE DATE_FORMAT(dbirth, CONCAT(YEAR(CURDATE()), '-%m-%d')) between CURDATE() and LAST_DAY(CURDATE()) LIMIT 100;
