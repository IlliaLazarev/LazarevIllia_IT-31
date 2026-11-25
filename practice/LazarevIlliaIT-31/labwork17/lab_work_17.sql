-- ЗАВДАННЯ 1. Наївний імпорт
CREATE TABLE memberships_staging_naive (
    type TEXT,
    duration_days INTEGER,
    price REAL
);

SELECT COUNT() FROM memberships_staging_naive;
SELECT FROM memberships_staging_naive LIMIT 1;

-- Очистити проміжну таблицю
DELETE FROM memberships_staging_naive;

-- ЗАВДАННЯ 2. Правильний імпорт
CREATE TABLE memberships_staging (
    type TEXT,
    duration_days INTEGER,
    price REAL
);

SELECT COUNT() FROM memberships_staging;
SELECT FROM memberships_staging LIMIT 10;

-- ЗАВДАННЯ 3. Перевірка порожніх значень
SELECT
    SUM(type = '') AS empty_type,
    SUM(duration_days = '') AS empty_duration,
    SUM(price = '') AS empty_price
FROM memberships_staging;

-- Перевірка типів
SELECT typeof(duration_days), COUNT()
FROM memberships_staging
GROUP BY typeof(duration_days);

SELECT typeof(price), COUNT()
FROM memberships_staging
GROUP BY typeof(price);

-- Пошук дублікатів
SELECT type, duration_days, price, COUNT() AS cnt
FROM memberships_staging
GROUP BY type, duration_days, price
HAVING COUNT() > 1;

-- Перевірка структури основної таблиці
.schema memberships

-- ЗАВДАННЯ 4. Перенесення даних
SELECT COUNT() AS count_before, MAX(id) AS max_id_before
FROM memberships;

-- Переносимо унікальні повні записи.
-- Порожні значення в обов'язкових полях не переносимо.
INSERT INTO memberships (type, duration_days, price)
SELECT DISTINCT
    type,
    CAST(NULLIF(duration_days, '') AS INTEGER),
    CAST(NULLIF(price, '') AS REAL)
FROM memberships_staging
WHERE type <> ''
  AND duration_days <> ''
  AND price <> '';

-- Перевірка результату
SELECT COUNT() AS count_after FROM memberships;
SELECT * FROM memberships ORDER BY id DESC LIMIT 10;
-- Видалення проміжних таблиць
DROP TABLE memberships_staging;
DROP TABLE memberships_staging_naive;

PRAGMA integrity_check;
PRAGMA foreign_key_check;
