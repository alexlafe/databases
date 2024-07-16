# 1
# Создайте копию таблицы о расписании занятий (из прошлого задания), добавив в нее информацию о времени каждого занятия.
ALTER TABLE subject_schedules ADD COLUMN `start` TIME;
ALTER TABLE subject_schedules ADD COLUMN `end` TIME;

# 2
# Заполните время по каждому предмету, предусмотрите возможные "окна" в расписании, не допускайте наложений одного предмета на другой.
CREATE TABLE `times`(`time` TIME);
INSERT INTO `times`(`time`) VALUES ('08:30'), ('10:10'), ('11:50');
CREATE TABLE subj_sch SELECT * FROM subject_schedules;

UPDATE subject_schedules SET `start`=(SELECT `time` FROM `times` ORDER BY RAND() LIMIT 1) WHERE `id` 
IN (SELECT MIN(`id`) FROM subj_sch GROUP BY `date`);

DROP TABLE subj_sch; CREATE TABLE subj_sch SELECT * FROM subject_schedules;
UPDATE subject_schedules SET `start`=(SELECT `start` + INTERVAL 1 HOUR + INTERVAL 40 MINUTE FROM subj_sch WHERE subj_sch.id=subject_schedules.id-1 LIMIT 1) WHERE `id` IN (SELECT MIN(`id`) + 1 FROM subj_sch GROUP BY `date`) AND start is NULL;

DROP TABLE subj_sch; CREATE TABLE subj_sch SELECT * FROM subject_schedules;
UPDATE subject_schedules SET `start`=(SELECT `start` + INTERVAL 1 HOUR + INTERVAL 40 MINUTE FROM subj_sch WHERE subj_sch.id=subject_schedules.id-1 LIMIT 1) WHERE `id` IN (SELECT MIN(`id`) + 2 FROM subj_sch GROUP BY `date`) AND start is NULL;

DROP TABLE subj_sch; CREATE TABLE subj_sch SELECT * FROM subject_schedules;
UPDATE subject_schedules SET `start`=(SELECT `start` + INTERVAL 1 HOUR + INTERVAL 40 MINUTE FROM subj_sch WHERE subj_sch.id=subject_schedules.id-1 LIMIT 1) WHERE `id` IN (SELECT MIN(`id`) + 3 FROM subj_sch GROUP BY `date`) AND start is NULL;

DROP TABLE subj_sch; CREATE TABLE subj_sch SELECT * FROM subject_schedules;
UPDATE subject_schedules SET `start`=(SELECT `start` + INTERVAL 1 HOUR + INTERVAL 40 MINUTE FROM subj_sch WHERE subj_sch.id=subject_schedules.id-1 LIMIT 1) WHERE `id` IN (SELECT MIN(`id`) + 4 FROM subj_sch GROUP BY `date`) AND start is NULL;

DROP TABLE subj_sch; CREATE TABLE subj_sch SELECT * FROM subject_schedules;
UPDATE subject_schedules SET `start`=(SELECT `start` + INTERVAL 1 HOUR + INTERVAL 40 MINUTE FROM subj_sch WHERE subj_sch.id=subject_schedules.id-1 LIMIT 1) WHERE `id` IN (SELECT MIN(`id`) + 5 FROM subj_sch GROUP BY `date`) AND start is NULL;

UPDATE subject_schedules SET `end`=`start` + INTERVAL 1 HOUR + INTERVAL 30 MINUTE;

# 3
# Создайте общее расписание занятий с учетом даты и времени, учитывая возможные "окна".
SELECT subject_schedules.date, subject_schedules.start, subject_schedules.end, subjects.name FROM subject_schedules, subjects WHERE subjects.id=subject_schedules.subject_id ORDER BY date, start LIMIT 100;

# 4
# Создайте индивидуальное расписание занятий для каждого студента с учетом даты и времени.
SELECT students.firstname, students.lastname, subject_schedules.date, subject_schedules.start, subject_schedules.end, subjects.name FROM subject_schedules, subjects, students WHERE subjects.id=subject_schedules.subject_id ORDER BY students.id, date, start LIMIT 100;

# 5
# Создайте представления для выше созданных расписаний.
CREATE VIEW `schedule_view` AS
SELECT subject_schedules.date, subject_schedules.start, subject_schedules.end, subjects.name FROM subject_schedules, subjects WHERE subjects.id=subject_schedules.subject_id ORDER BY date, start;

CREATE VIEW `student_schedule` AS
SELECT students.firstname, students.lastname, subject_schedules.date, subject_schedules.start, subject_schedules.end, subjects.name FROM subject_schedules, subjects, students WHERE subjects.id=subject_schedules.subject_id ORDER BY students.id, date, start;

# 6
# Создайте представления для быстрого нахождения запросов из предыдущего задания.
CREATE VIEW `marks_view` AS
SELECT students.firstname, students.lastname, subjects.name, mark FROM students, student_marks, subjects WHERE students.id=student_marks.student_id AND student_marks.subject_id=subjects.id;

# 7
# Сделайте несколько выборок из представлений, снабжая их условиями, группировками и сортировками.

# Кол-во тех или иных оценок
SELECT firstname, lastname, mark, COUNT(mark) AS `Кол-во оценок` FROM marks_view GROUP BY firstname, lastname, mark;

# Средний балл
SELECT firstname, lastname, AVG(mark) AS `Средний балл` FROM marks_view GROUP BY firstname, lastname;

# Самый успевающий студент
SELECT firstname, lastname FROM marks_view GROUP BY firstname, lastname ORDER BY AVG(mark) DESC LIMIT 1;

# Средний балл по каждой из дисциплин
SELECT name, AVG(mark) FROM marks_view GROUP BY name ORDER BY AVG(mark);
