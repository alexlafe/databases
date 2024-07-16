# 1.
# a. 
SELECT id, UPPER(name) FROM clients;
# b. 
SELECT id, LOWER(name) FROM clients;
# 2. 
SELECT CONCAT(lastname, " ", name) AS full_name, CONCAT(RIGHT(phone, 3), "***", LEFT(phone, 1)) as phone_number FROM clients;
# 3. 
SELECT CONCAT(UPPER(RIGHT(name, 1)), ". ", lastname) as "full_name" FROM clients WHERE lastname REGEXP '(tt|ss|ll)';
# 4. 
# a. 
SELECT name, lastname, phone FROM clients WHERE phone LIKE '586%';
# b. 
SELECT name, lastname, phone FROM clients WHERE phone LIKE '%657%';
# c. 
SELECT name, lastname, phone FROM clients WHERE phone LIKE '%707';
