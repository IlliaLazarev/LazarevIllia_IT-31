-- Практична робота №13. Форматування таблиць за допомогою printf і дат
-- Варіант 7: спортивний зал / фітнес-клуб
-- Використовується та сама структура бази, що й у практичній №12.
-- Таблиці: memberships, membership_sales, clients.
-- Структура таблиць не змінюється.

-- Завдання 1. printf() — ціна з двома знаками після крапки
SELECT
    id,
    type,
    price AS raw_price,
    printf('%.2f грн', price) AS formatted_price
FROM memberships
ORDER BY id;
-- Результат виконання:
-- 1 | one-time | 150.0 | 150.00 грн
-- 2 | weekly | 500.0 | 500.00 грн
-- 3 | monthly | 1200.0 | 1200.00 грн
-- 4 | quarterly | 3000.0 | 3000.00 грн
-- 5 | yearly | 9500.0 | 9500.00 грн
-- 6 | student monthly | 800.0 | 800.00 грн

-- Завдання 2. printf() — вирівнювання ширини поля
SELECT
    id,
    type,
    printf('%8.2f', price) AS aligned_price
FROM memberships
ORDER BY id;
-- Результат виконання:
-- 1 | one-time |   150.00
-- 2 | weekly |   500.00
-- 3 | monthly |  1200.00
-- 4 | quarterly |  3000.00
-- 5 | yearly |  9500.00
-- 6 | student monthly |   800.00

-- Завдання 3. date() — дата завершення + 30 днів
SELECT
    id,
    purchase_date,
    expiration_date,
    date(expiration_date, '+30 days') AS extended_expiration_date
FROM membership_sales
ORDER BY id;
-- Результат виконання:
-- 1 | 2026-09-01 | 2026-10-01 | 2026-10-31
-- 2 | 2026-09-02 | 2026-09-09 | 2026-10-09
-- 3 | 2026-09-03 | 2026-12-02 | 2027-01-01
-- 4 | 2026-09-04 | 2026-10-04 | 2026-11-03
-- 5 | 2026-09-05 | 2026-09-06 | 2026-10-06
-- 6 | 2026-09-06 | 2027-09-06 | 2027-10-06
-- 7 | 2026-09-07 | 2026-10-07 | 2026-11-06
-- 8 | 2026-09-08 | 2026-09-15 | 2026-10-15
-- 9 | 2026-09-09 | 2026-10-09 | 2026-11-08
-- 10 | 2026-09-10 | 2026-12-09 | 2027-01-08

-- Завдання 4. strftime() та GROUP BY за місяцем
SELECT
    strftime('%Y-%m', purchase_date) AS purchase_month,
    COUNT(*) AS sales_count
FROM membership_sales
GROUP BY purchase_month
ORDER BY purchase_month;
-- Результат виконання:
-- 2026-09 | 10

-- Завдання 5. Свідома помилка — некоректна дата
SELECT
    'not-a-date' AS invalid_input,
    strftime('%Y', 'not-a-date') AS extracted_year,
    date('not-a-date') AS parsed_date;
-- Результат виконання:
-- not-a-date | NULL | NULL

-- Додаткові контрольні запити для перевірки:
-- printf() змінює лише представлення результату, а не значення в таблиці.
SELECT price AS stored_price, printf('%.2f грн', price) AS displayed_price
FROM memberships;

-- strftime('%Y', ...) повертає текстове значення року.
SELECT strftime('%Y', purchase_date) AS year_text, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY year_text
ORDER BY year_text;
