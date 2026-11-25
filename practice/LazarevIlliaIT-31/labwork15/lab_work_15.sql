-- Завдання 1. План запиту ДО створення індексу на client_id.
EXPLAIN QUERY PLAN
SELECT * FROM membership_sales
WHERE client_id = 1;
-- Фактичний план до індексу:
-- 2 | 0 | 0 | SCAN membership_sales

-- Завдання 2. Індекс на зовнішньому ключі client_id.
CREATE INDEX idx_sales_client
ON membership_sales(client_id);

EXPLAIN QUERY PLAN
SELECT * FROM membership_sales
WHERE client_id = 1;
-- Фактичний план після індексу:
-- 3 | 0 | 0 | SEARCH membership_sales USING INDEX idx_sales_client (client_id=?)

-- Завдання 3. Композитний індекс на двох колонках.
-- Спочатку перевіряємо план без композитного індексу.
EXPLAIN QUERY PLAN
SELECT * FROM membership_sales
WHERE client_id = 1 AND membership_id = 3;
-- План до композитного індексу:
-- 3 | 0 | 0 | SEARCH membership_sales USING INDEX idx_sales_client (client_id=?)

CREATE INDEX idx_sales_client_membership
ON membership_sales(client_id, membership_id);

EXPLAIN QUERY PLAN
SELECT * FROM membership_sales
WHERE client_id = 1 AND membership_id = 3;
-- План після композитного індексу:
-- 3 | 0 | 0 | SEARCH membership_sales USING INDEX idx_sales_client_membership (client_id=? AND membership_id=?)

-- Завдання 4. Індекс на колонці purchase_date та сортування.
EXPLAIN QUERY PLAN
SELECT * FROM membership_sales
ORDER BY purchase_date;
-- План до індексу дати:
-- 3 | 0 | 0 | SCAN membership_sales
-- 13 | 0 | 0 | USE TEMP B-TREE FOR ORDER BY

CREATE INDEX idx_sales_purchase_date
ON membership_sales(purchase_date);

EXPLAIN QUERY PLAN
SELECT * FROM membership_sales
ORDER BY purchase_date;
-- План після індексу дати:
-- 4 | 0 | 0 | SCAN membership_sales USING INDEX idx_sales_purchase_date

-- Завдання 5. Видаляємо індекс дати та перевіряємо план повторно.
DROP INDEX idx_sales_purchase_date;

EXPLAIN QUERY PLAN
SELECT * FROM membership_sales
ORDER BY purchase_date;
-- План після видалення індексу:
-- 
3 | 0 | 0 | SCAN membership_sales-- 13 | 0 | 0 | USE TEMP B-TREE FOR ORDER BY

-- Перевіряємо, що індекс дати видалено.
SELECT name
FROM sqlite_master
WHERE type = 'index'
  AND name = 'idx_sales_purchase_date';
-- Очікуваний результат: 0 рядків.

-- Переглядаємо індекси, які залишилися.
SELECT name, sql
FROM sqlite_master
WHERE type = 'index'
  AND name NOT LIKE 'sqlite_autoindex%'
ORDER BY name;

-- Примітка: у фінальній базі залишаються idx_sales_client
-- та idx_sales_client_membership. Індекс purchase_date видалено.
