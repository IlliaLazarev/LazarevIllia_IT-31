PRAGMA foreign_keys = ON;

-- Завдання 1. ORDER BY за однією колонкою
SELECT id, membership_id, client_id, purchase_date, expiration_date
FROM membership_sales
ORDER BY purchase_date DESC;
-- Результат перевірки:
-- 10 | 4 | 2 | 2026-09-10 | 2026-12-09
-- 9 | 6 | 1 | 2026-09-09 | 2026-10-09
-- 8 | 2 | 4 | 2026-09-08 | 2026-09-15
-- 7 | 3 | 3 | 2026-09-07 | 2026-10-07
-- 6 | 5 | 2 | 2026-09-06 | 2027-09-06
-- 5 | 1 | 1 | 2026-09-05 | 2026-09-06
-- 4 | 6 | 4 | 2026-09-04 | 2026-10-04
-- 3 | 4 | 3 | 2026-09-03 | 2026-12-02
-- 2 | 2 | 2 | 2026-09-02 | 2026-09-09
-- 1 | 3 | 1 | 2026-09-01 | 2026-10-01

-- Завдання 2. ORDER BY за кількома колонками
SELECT id, membership_id, client_id, purchase_date
FROM membership_sales
ORDER BY membership_id ASC, purchase_date DESC;
-- Результат перевірки:
-- 5 | 1 | 1 | 2026-09-05
-- 8 | 2 | 4 | 2026-09-08
-- 2 | 2 | 2 | 2026-09-02
-- 7 | 3 | 3 | 2026-09-07
-- 1 | 3 | 1 | 2026-09-01
-- 10 | 4 | 2 | 2026-09-10
-- 3 | 4 | 3 | 2026-09-03
-- 6 | 5 | 2 | 2026-09-06
-- 9 | 6 | 1 | 2026-09-09
-- 4 | 6 | 4 | 2026-09-04

-- Завдання 3. Топ-3 найновіші продажі
SELECT id, membership_id, client_id, purchase_date
FROM membership_sales
ORDER BY purchase_date DESC
LIMIT 3;
-- Результат перевірки:
-- 10 | 4 | 2 | 2026-09-10
-- 9 | 6 | 1 | 2026-09-09
-- 8 | 2 | 4 | 2026-09-08

-- Завдання 4а. DISTINCT типи абонементів
SELECT DISTINCT type
FROM memberships
ORDER BY type;
-- Результат перевірки:
-- monthly
-- one-time
-- quarterly
-- student monthly
-- weekly
-- yearly

-- Завдання 4б. IN для вибору трьох типів абонементів
SELECT id, type, duration_days, price
FROM memberships
WHERE id IN (1, 2, 3)
ORDER BY id;
-- Результат перевірки:
-- 1 | one-time | 1 | 150.0
-- 2 | weekly | 7 | 500.0
-- 3 | monthly | 30 | 1200.0

-- Завдання 5а. LIKE з великої кириличної літери
SELECT id, first_name, last_name
FROM clients
WHERE last_name LIKE 'П%';
-- Результат перевірки:
-- 1 | Іван | Петренко

-- Завдання 5б. LIKE з малої кириличної літери
SELECT id, first_name, last_name
FROM clients
WHERE last_name LIKE 'п%';
-- Результат перевірки:
-- Запит не повернув рядків.

-- Додатковий контроль: кількість унікальних типів абонементів
-- Очікуваний результат: 6
SELECT COUNT(DISTINCT type) AS unique_membership_types
FROM memberships;

-- Контрольні питання:
-- 1. ORDER BY виконується до LIMIT, тому спочатку всі рядки сортуються,
--    а потім обираються перші три. Без ORDER BY LIMIT 3 поверне довільні
--    три рядки без гарантії, що вони є найновішими.
-- 2. IN доречний для перевірки належності до конкретного переліку значень;
--    BETWEEN — для безперервного числового або датового діапазону.
-- 3. У SQLite LIKE для кирилиці може враховувати регістр: 'П%' і 'п%'
--    можуть повертати різну кількість рядків.
