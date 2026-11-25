-- Практична робота 16. Імпорт CSV в SQLite
-- Варіант 7. Таблиця memberships

-- 1. Кількість записів до імпорту
SELECT COUNT(*) AS count_before
FROM memberships;

-- 2. Створення проміжної таблиці
CREATE TABLE memberships_staging (
    type TEXT,
    duration_days INTEGER,
    price REAL
);

-- 3. Імпорт CSV виконується в SQLite CLI:
-- .mode csv
-- .import --skip 1 v7_new_rows.csv memberships_staging

-- 4. Перевірка імпортованих даних
SELECT * FROM memberships_staging;

-- 5. Перенесення даних до основної таблиці
INSERT INTO memberships (type, duration_days, price)
SELECT type, duration_days, price
FROM memberships_staging;

-- 6. Видалення проміжної таблиці
DROP TABLE memberships_staging;

-- 7. Перевірка кількості записів після імпорту
SELECT COUNT(*) AS count_after
FROM memberships;

-- 8. Перевірка нових абонементів
SELECT *
FROM memberships
ORDER BY id DESC
LIMIT 8;

-- 9. Перевірка цілісності бази
PRAGMA integrity_check;
PRAGMA foreign_key_check;